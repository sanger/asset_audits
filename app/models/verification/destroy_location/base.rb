# frozen_string_literal: true
#
# Takes a location barcode and validates the location for having child locations and that all labware
# are older than the lifespan defined by their purpose
class Verification::DestroyLocation::Base < Verification::Base
  include Verification::LabwhereApi
  validates_with Verification::Validator::DestroyLocationScanned
  self.partial_name = "destroy_location"

  def scanned_values
    return [] unless @attributes[:scanned_values]
    [@attributes[:scanned_values]].flatten.map { |s| s.split(/\s/).compact_blank }.flatten
  end

  # Scans the source plates into the LabWhere destroyed location and creates audits for them.
  # The parameters are the ProcessPlatesController parameters for the Destroying labware process.
  # This method is called by the create action of the controller.
  # @param params [Hash] the parameters passed to the controller action
  #
  # @return [Boolean] returns true if the scanning, and audit creation were all successful, and false otherwise.
  def validate_and_create_audits?(params) # rubocop:disable Metrics/MethodLength
    @process_plate ||= create_process_plate(params)

    unless process_plate.valid?
      save_errors_to_base(process_plate.errors)
      return false
    end

    if params[:robot].blank?
      errors.add(:base, "No labware found")
      return false
    end
    return false unless scan_into_destroyed_location(params[:user_barcode], params[:robot]&.split(/\r?\n/))

    super
  end

  # Validates the location barcode and retrieves the labware barcodes from the location
  # and validates that all labware are older than the lifespan defined by their purpose
  def pre_validate
    @barcodes if valid?
  end

  # Retrieves the labware barcodes from the location and validates that all labware are older than the lifespan defined
  # by their purpose
  def labware_from_location(barcode) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    location_info = location_info(barcode)

    # Return if location_info is nil or if the location does not have any child locations or labware
    return if location_info.nil? || (location_info[:depth].nil? && location_info[:labwares].nil?)

    # Return if the location has any child locations.
    # The destrucrion of labware is only allowed for bottom-level locations.
    if location_info[:depth] != 0
      errors.add(:LabWhere, "Location has child location")
      return
    end

    # Return if the location does not have any labware
    if location_info[:labwares].empty?
      errors.add(:LabWhere, "Location does not have any labware")
      return
    end

    # Get the barcodes of the labware in the location and validate that they are older than the lifespan defined by
    # their purpose
    @barcodes = location_info[:labwares].pluck("barcode")
    outdated_labware = Verification::OutdatedLabware::Base.new
    outdated_labware.labware_from_barcodes(@barcodes)
  end

  def create_process_plate(params)
    params[:source_plates] = scanned_values.flatten.join(" ")
    ProcessLabware.new(
      user_barcode: params[:user_barcode],
      instrument_barcode: params[:instrument_barcode],
      source_plates: params[:source_plates],
      visual_check: params[:visual_check] == "1",
      instrument_process_id: params[:instrument_process],
      witness_barcode: params[:witness_barcode],
      metadata: metadata(params)
    )
  end
end

# frozen_string_literal: true
#
# Takes a list of source labware and validates that all labware
# are older than the lifespan defined by their purpose
class Verification::OutdatedLabware::Base < Verification::Base
  include Verification::LabwhereApi
  validates_with Verification::Validator::OutdatedPlatesScanned

  self.partial_name = "outdated_labware"

  def scanned_values
    [@attributes[:scanned_values]].flatten.map { |s| s.split(/\s/).compact_blank }.flatten
    
  end

  def labware_from_barcodes(barcodes)
    labware_list = Sequencescape::Api::V2::Labware.where(barcode: barcodes)
    labware_hash = labware_list.index_by { |labw| labw.labware_barcode["machine_barcode"] }
    barcodes.index_with { |barcode| labware_hash[barcode] }
  end

  # Validates the Destroying labware instrument process, scans the source
  # plates into the LabWhere destroyed location and creates audits for them.
  # The parameters are the ProcessPlatesController parameters for the
  # Destroying labware process. This method is called by the create action
  # of the controller.
  #
  # @param params [Hash] the parameters passed to the controller action
  #
  # @return [Boolean] returns true if the validation, scanning, and audit
  # creation were all successful, and false otherwise.
  def validate_and_create_audits?(params)
    return false unless valid?
    
    return false unless scan_into_destroyed_location(params[:user_barcode],scanned_values)

    params[:source_plates] = scanned_values.flatten.join(" ")
    super
  end


 
end

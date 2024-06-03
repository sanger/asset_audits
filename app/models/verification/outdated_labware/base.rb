# frozen_string_literal: true

#
# Takes a list of source labware and validates that all labware
# are older than the lifespan defined by their purpose
class Verification::OutdatedLabware::Base < Verification::Base
  validates_with Verification::Validator::OutdatedPlatesScanned
  class_attribute :destroyed_location_barcode

  self.partial_name = "outdated_labware"
  self.destroyed_location_barcode = "lw-destroyed"

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

    return false unless scan_into_destroyed_location(params)

    params[:source_plates] = scanned_values.flatten.join(" ")
    super
  end

  # Sends a POST request to the LabWhere API to scan the labware into the
  # destroyed location. The parameters passed to the ProcessPlatesController
  # for the Destroying labware process are used to construct the payload.
  # If an error occurs, the error message will be added to the errors object,
  # with the LabWhere attribute.
  #
  # @param params [Hash] the parameters passed to the process_plates action
  #
  # @return [Boolean] returns true if the request was successful, and false
  # if an error occurred.
  # :reek:TooManyStatements
  def scan_into_destroyed_location(params)
    destroyed_location_uri = URI.join(Settings.labwhere_api, "scans").to_s
    RestClient.post(destroyed_location_uri, destroyed_location_payload(params))
    true
  rescue Errno::ECONNREFUSED, RestClient::NotFound
    errors.add(:LabWhere, "LabWhere service is down")
    false
  rescue RestClient::UnprocessableEntity => e
    errors.add(:LabWhere, JSON.parse(e.response.body)["errors"].join(", "))
    false
  end

  # Constructs the payload for a scan into the LabWhere destroyed location. The
  # parameters passed to the ProcessPlatesController for the Destroying labware
  # process are used to construct the payload. The payload is a hash with a
  # single key, :scan, which maps to another hash. This inner hash contains
  # the following keys:
  # - :user_code: the barcode of the user performing the scan
  # - :labware_barcodes: a newline-separated string of the barcodes
  # - :location_barcode: the barcode of the destroyed location

  # @param params [Hash] the parameters passed to the create action
  #
  # @return [Hash] the constructed payload
  #
  def destroyed_location_payload(params)
    {
      scan: {
        user_code: params[:user_barcode],
        labware_barcodes: scanned_values.join('\n'),
        location_barcode: destroyed_location_barcode
      }
    }
  end
end

# frozen_string_literal: true

require "net/http"

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

  private

  # Sends a POST request to the LabWhere API to scan the labware into the
  # destroyed location. The parameters passed to the ProcessPlatesController
  # for the Destroying labware process are used to construct the payload.
  # If an error occurs, the error message will be added to the errors object,
  # with the LabWhere attribute.
  #
  # @param params [Hash] the parameters passed to the create action
  #
  # @return [Boolean] returns true if the request was successful, and false
  # if an error occurred.
  def scan_into_destroyed_location(params)
    response = send_scan_request(params)
    handle_scan_response(response)
  rescue Errno::ECONNREFUSED
    errors.add(:LabWhere, "LabWhere service is down")
    false
  end

  # Sends a POST request to the LabWhere API to scan the abware into the
  # destroyed location.
  #
  # @param params [Hash] The parameters to prepare the scan request.
  # @return [Net::HTTPResponse] The HTTP response from the LabWhere API.
  def send_scan_request(params)
    uri = URI.join(Settings.labwhere_api, "scans")
    data = destroyed_location_payload(params).to_json
    headers = { "Content-Type" => "application/json" }
    Net::HTTP.post(uri, data, headers)
  end

  # Handles the response from the LabWhere API after scanning the labware into
  # destroyed location.
  #
  # @param response [Net::HTTPResponse] the response from the LabWhere API
  # @return [Boolean] Returns true if the response is a success, false otherwise.
  #
  def handle_scan_response(response)
    return true if response.is_a?(Net::HTTPSuccess)

    case response
    when Net::HTTPNotFound
      errors.add(:LabWhere, "LabWhere service is down")
    when Net::HTTPUnprocessableEntity
      errors.add(:LabWhere, JSON.parse(response.body)["errors"].join(", "))
    else
      errors.add(:LabWhere, "An error occurred while scanning the labware")
    end

    false
  end

  # Constructs the payload for a scan into the LabWhere destroyed location. The
  # returned payload is a hash with a single key, :scan, which maps to another
  # hash. This inner hash contains the following keys:
  # - :user_code: the swipe card or barcode code of the user performing the scan
  # - :labware_barcodes: a newline-separated string of the barcodes
  # - :location_barcode: the barcode of the destroyed location
  #
  # @param params [Hash] the parameters passed to the create action
  #
  # @return [Hash] the constructed payload
  #
  def destroyed_location_payload(params)
    # Using double quotes is important to process the newlines correctly for
    # building the labware_barcodes string in the format expected by LabWhere.
    delimiter = "\n"
    {
      scan: {
        user_code: params[:user_barcode],
        labware_barcodes: scanned_values.join(delimiter),
        location_barcode: destroyed_location_barcode
      }
    }
  end
end

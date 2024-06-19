# frozen_string_literal: true
require "net/http"
module Verification::LabwhereApi 

 HEADERS = { "Content-Type" => "application/json" }.freeze
 BASE_URL = Settings.labwhere_api.freeze
 DESTROY_LOCATION_BARCODE = "lw-destroyed"

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
   def scan_into_destroyed_location(user_barcode,barcodes)
    response = send_scan_request(user_barcode,barcodes)
    handle_scan_response(response)
  rescue Errno::ECONNREFUSED
    errors.add(:LabWhere, "LabWhere service is down")
    false
  end
  


  def location_info(barcode) # rubocop:disable Metrics/MethodLength
    uri = URI.join(BASE_URL, "locations/info")
    uri.query = URI.encode_www_form({ barcode:})
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri, HEADERS))
    if response.is_a?(Net::HTTPSuccess)
        # Parse the response body
        response_body = JSON.parse(response.body)
        depth  = response_body["depth"]
        # Extract the first element of the response, which is an array of labware
        labwares = response_body["labwares"]
        { depth: , labwares:  }
    else
        add_error_from_response(response)
        nil
    end
  rescue Errno::ECONNREFUSED
    errors.add(:LabWhere, "LabWhere service is down")
    nil
  end

  private
  
  # Sends a POST request to the LabWhere API to scan the labware into the
  # destroyed location.
  #
  # @param params [Hash] The parameters to prepare the scan request.
  # @return [Net::HTTPResponse] The HTTP response from the LabWhere API.
  def send_scan_request(user_barcode,barcodes)
    uri = URI.join(BASE_URL, "scans")
    data = destroyed_location_payload(user_barcode,barcodes).to_json
    Net::HTTP.post(uri, data, HEADERS)
  end

  # Handles the response from the LabWhere API after scanning the labware into
  # destroyed location.
  #
  # @param response [Net::HTTPResponse] the response from the LabWhere API
  # @return [Boolean] Returns true if the response is a success, false otherwise.
  #
  def handle_scan_response(response)
    return true if response.is_a?(Net::HTTPSuccess)
    add_error_from_response(response)
    false
  end

  def add_error_from_response(response)
    case response
    when Net::HTTPNotFound
      errors.add(:LabWhere, "LabWhere service is down")
    when Net::HTTPUnprocessableEntity
      errors.add(:LabWhere, JSON.parse(response.body)["errors"].join(", "))
    else
      errors.add(:LabWhere, "An error occurred while scanning the labware")
    end
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
  def destroyed_location_payload(user_barcode,barcodes)
    {
      scan: {
        user_code: user_barcode,
        labware_barcodes: barcodes.join("\n"),
        location_barcode: DESTROY_LOCATION_BARCODE
      }
    }
  end

  
end
require "net/http"

#
# Takes a location barcode and validates the location for having child locations and that all labware
# are older than the lifespan defined by their purpose
class Verification::DestroyLocation::Base < Verification::OutdatedLabware::Base
  
validates_with Verification::Validator::DestroyLocationScanned    
self.partial_name = "destroy_location"

def scanned_values
    @attributes[:scanned_values].split(/\s/).compact_blank
end

def validate_and_create_audits?(params)
    byebug
    return false unless valid?

    byebug
    return false unless scan_into_destroyed_location(@barcodes.join("\r\n"))

    params[:source_plates] = scanned_values.flatten.join(" ")
    super
end
 

def labware_from_location(barcode) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    uri = URI.join(Settings.labwhere_api, "locations/hierarchy")
    uri.query = URI.encode_www_form({ barcode:})
    headers = { "Content-Type" => "application/json" }
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri, headers))

    if response.is_a?(Net::HTTPSuccess)
        # Parse the response body
        response_body = JSON.parse(response.body)
        hierarchy_depth  = response_body[1]
        if hierarchy_depth < 1
            errors.add(:LabWhere, "Location does not have any child locations")
            return
        end
        # Extract the first element of the response, which is an array of labware
        labwares = response_body.first
        # Map over the labwares and return the barcode
        @barcodes =  labwares.pluck("barcode")
        labware_from_barcodes(@barcodes)
         
    else
        error_message = JSON.parse(response.body)["error"]
        errors.add(:LabWhere, error_message)
    end
  end
end
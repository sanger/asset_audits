#
# Takes a location barcode and validates the location for having child locations and that all labware
# are older than the lifespan defined by their purpose
class Verification::DestroyLocation::Base  < Verification::Base

include Verification::LabwhereApi
validates_with Verification::Validator::DestroyLocationScanned    
self.partial_name = "destroy_location"

def scanned_values
     @attributes[:scanned_values]&.split(/\s/)
  end

def validate_and_create_audits?(params)
    return false unless scan_into_destroyed_location(params[:user_barcode],@barcodes)

    params[:source_plates] = scanned_values.flatten.join(" ")
    super
end
 
def pre_validate?(params)
     @attributes[:scanned_values] = params["scanned_values"]
    @barcodes if valid?
end

def labware_from_location(barcode)  # rubocop:disable Metrics/MethodLength
    location_info = location_info(barcode)
    if(location_info[:depth].nil? || location_info[:labwares].nil?)
        errors.add(:LabWhere, "Failed to get location information for #{barcode}")
        return
    end
    if location_info[:depth] < 1
        errors.add(:LabWhere, "Location does not have any child locations")
        return
    end

    @barcodes =   location_info[:labwares].pluck("barcode")
    outdated_labware = Verification::OutdatedLabware::Base.new
    outdated_labware.labware_from_barcodes(@barcodes)
end
end
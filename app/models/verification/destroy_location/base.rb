#
# Takes a location barcode and validates the location for having child locations and that all labware
# are older than the lifespan defined by their purpose
class Verification::DestroyLocation::Base  < Verification::Base

include Verification::LabwhereApi
validates_with Verification::Validator::DestroyLocationScanned    
self.partial_name = "destroy_location"

def validate_and_create_audits?(params)
    return false unless scan_into_destroyed_location(params[:user_barcode],params[:robot]&.split("\r\n"))

    params[:source_plates] = scanned_values
    super
end
 
def pre_validate
    @barcodes if valid?
end

def labware_from_location(barcode) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  location_info = location_info(barcode)

  return if location_info.nil?|| (location_info[:depth].nil? && location_info[:labwares].nil?)

  if location_info[:depth] < 1
    errors.add(:LabWhere, "Location does not have any child locations")
    return
  end

  if location_info[:labwares].empty?
    errors.add(:LabWhere, "Location does not have any labware")
    return
  end

  @barcodes = location_info[:labwares].pluck("barcode")
  outdated_labware = Verification::OutdatedLabware::Base.new
  outdated_labware.labware_from_barcodes(@barcodes)
end
end
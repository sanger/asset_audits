# frozen_string_literal: true

#
# Takes a list of source plates and validates that all plates
# are older than the lifespan defined by their plate purpose
class Verification::OutdatedLabware::Base < Verification::Base
  validates_with Verification::Validator::OutdatedPlatesScanned

  attr_accessor :plate_barcodes_to_destroy, :messages

  self.partial_name = 'outdated_labware'

  def scanned_values
    [@attributes[:scanned_values]].flatten.map { |s| s.split(/\s/).reject(&:blank?) }.flatten
  end

  def search_resource
    api.search.find(Settings.search_find_assets_by_barcode)
  end

  def plates_from_barcodes(barcodes)
    plates = search_resource.all(api.plate, barcode: barcodes)
    plate_hash = plates.index_by { |plate| plate.barcode.machine }
    barcodes.to_h { |barcode| [barcode, plate_hash[barcode]] }
  end

  def validate_and_create_audits?(params)
    return false unless valid?

    params[:source_plates] = scanned_values.flatten.join(' ')
    super(params)
  end
end

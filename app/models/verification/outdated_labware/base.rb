# frozen_string_literal: true

#
# Takes a list of source plates and validates that all plates
# are older than the lifespan defined by theit plate purpose
class Verification::OutdatedLabware::Base < Verification::Base
  validates_with Verification::Validator::OutdatedPlatesScanned

  attr_accessor :plate_barcodes_to_destroy, :messages

  self.partial_name = 'outdated_labware'

  def scanned_values
    [@attributes[:scanned_values]].flatten.map do |s|
      s.split(/\s/).reject(&:blank?)
    end.flatten
  end

  def search_resource
    api.search.find(Settings.search_find_assets_by_barcode)
  end

  def plates_from_barcodes(barcodes)
    plates = search_resource.all(api.plate,
                                 barcode: barcodes)
    plate_hash = plates.map { |plate| [plate.barcode.machine, plate] }.to_h
    barcodes.map do |barcode|
      [barcode, plate_hash[barcode]]
    end.to_h
  end

  def validate_and_create_audits?(params)
    return false unless valid?

    params[:source_plates] = scanned_values.flatten.join(' ')
    super(params)
  end
end

class Verification::OutdatedLabware::Base < Verification::Base
  validates_with Verification::Validator::OutdatedPlatesScanned

  attr_accessor :plate_barcodes_to_destroy

  attr_accessor :messages

  self.partial_name = "outdated_labware"

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
      :barcode => barcodes)
    plate_hash = Hash[plates.map {|plate| [plate.barcode.ean13, plate]} ]
    Hash[barcodes.map do |barcode|
      [barcode,plate_hash[barcode]]
    end]
  end

  def validate_and_create_audits?(params)
    return false unless valid?
    params[:source_plates] = scanned_values.flatten.join(" ")
    return super(params)
  end
end

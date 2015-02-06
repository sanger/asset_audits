class Verification::OutdatedLabware::Base < Verification::Base
  validates_with Verification::Validator::OutdatedPlatesScanned

  attr_accessor :plate_barcodes_to_destroy

  attr_accessor :messages

  def self.partial_name
    "outdated_labware"
  end

  def scanned_values
    [@attributes[:scanned_values]].flatten.map do |s|
      s.split(/\s/).reject(&:blank?)
    end.flatten
  end

  def get_search_instance
    api.search.find(Settings.search_find_assets_by_barcode)
  end

  def plates_from_barcodes(barcodes)
    obj = get_search_instance.all(api.plate,
      :barcode => barcodes).reduce({}) do |memo, plate|
      memo[plate.barcode.ean13] = plate
      memo
    end
    barcodes.each do |barcode|
      obj[barcode] = nil if obj[barcode].nil?
    end
    obj
  end

  def validate_and_create_audits?(params)
    return false unless valid?
    params[:source_plates] = scanned_values.flatten.join(" ")
    return super(params)
  end
end

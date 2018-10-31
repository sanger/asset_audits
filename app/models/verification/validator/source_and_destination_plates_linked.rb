# frozen_string_literal: true
class Verification::Validator::SourceAndDestinationPlatesLinked < ActiveModel::Validator
  def validate(record)
    record.parse_source_and_destination_barcodes(record.scanned_values).reject do |source_barcode, destination_barcode|
      destination_barcode.blank? || source_barcode.blank?
    end.tap do |source_and_destinations|
      search_resource = record.api.search.find(Settings.search_find_source_assets_by_destination_barcode)
      source_and_destinations.all? do |source_barcode, destination_barcode|
        search_results = search_resource.all(record.api.plate, barcode: destination_barcode)
        valid_source_barcode?(source_barcode, search_results, record)
      end
    end
  end

  def valid_source_barcode?(source_barcode, search_results, record)
    return true if search_results.map { |p| p.barcode.ean13 }.include?(source_barcode)
    record.errors[:base] << 'Invalid source plate layout'
    return false
  end
  private :valid_source_barcode?
end

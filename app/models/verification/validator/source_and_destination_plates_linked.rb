class Verification::Validator::SourceAndDestinationPlatesLinked < ActiveModel::Validator
  def validate(record)
    record.parse_source_and_destination_barcodes(record.scanned_values).each do |source_barcode, destination_barcode|
      next if destination_barcode.blank? || source_barcode.blank?
      search_resource = record.api.search.find(Settings.search_find_source_assets_by_destination_barcode)
      search_results = search_resource.all(record.api.plate, :barcode => destination_barcode)
      return unless valid_source_barcode?(source_barcode, search_results, record)
    end
  end
  
  private
  def valid_source_barcode?(source_barcode, search_results, record)
    unless source_barcodes_from_search_results(search_results).include?(source_barcode)
      record.errors[:base] << "Invalid source plate layout"
      return false
    end
    
    true
  end

  def source_barcodes_from_search_results(search_results)
    search_results.flatten.map(&:barcode).map(&:ean13)
  end
end

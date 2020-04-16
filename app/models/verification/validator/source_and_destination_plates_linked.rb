# frozen_string_literal: true
class Verification::Validator::SourceAndDestinationPlatesLinked < ActiveModel::Validator
  def validate(record)
    record.parse_source_and_destination_barcodes(record.scanned_values).reject do |source_barcode, destination_barcode|
      destination_barcode.blank? || source_barcode.blank?
    end.tap do |source_and_destinations|
      # search_resource = record.api.search.find(Settings.search_find_source_assets_by_destination_barcode)
      source_and_destinations.all? do |source_barcode, destination_barcode|
        # search_results = search_resource.all(record.api.plate, barcode: destination_barcode)
        search_results = Sequencescape::Api::V2::Plate.where(barcode: destination_barcode).first.parents
        # found_barcodes = search_results.map { |p| p.barcode.machine }
        found_barcodes = search_results.map { |p| p.labware_barcode['machine_barcode'] }
        valid_source_barcode?(source_barcode, found_barcodes, record, destination_barcode)
      end
    end
  end

  private

  def valid_source_barcode?(source_barcode, found_barcodes, record, destination_barcode)
    return true if found_barcodes.include?(source_barcode)
    parent_error = case found_barcodes.length
                   when 0 then "#{destination_barcode} has no known parents."
                   when 1 then "Known parent is #{found_barcodes.first}."
                   else "Known parents are #{found_barcodes.join(', ')}"
                   end
    record.errors[:base] << "Invalid source plate layout: #{source_barcode} is not a parent of #{destination_barcode}. "\
                            "#{parent_error}"
    return false
  end
end

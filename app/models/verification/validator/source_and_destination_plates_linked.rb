# frozen_string_literal: true

class Verification::Validator::SourceAndDestinationPlatesLinked < ActiveModel::Validator
  def validate(record) # rubocop:todo Metrics/AbcSize
    record
      .parse_source_and_destination_barcodes(record.scanned_values)
      .reject { |source_barcode, destination_barcode| destination_barcode.blank? || source_barcode.blank? }
      .tap do |source_and_destinations|
        source_and_destinations.all? do |source_barcode, destination_barcode|
          found_barcodes = []
          search_results = Sequencescape::Api::V2::Plate.where(barcode: destination_barcode).first&.parents
          found_barcodes = search_results.map { |p| p.labware_barcode['machine_barcode'] } if search_results
          valid_source_barcode?(source_barcode, found_barcodes, record, destination_barcode)
        end
      end
  end

  private

  def valid_source_barcode?(source_barcode, found_barcodes, record, destination_barcode) # rubocop:todo Metrics/MethodLength
    return true if found_barcodes.include?(source_barcode)

    parent_error =
      case found_barcodes.length
      when 0
        "#{destination_barcode} has no known parents."
      when 1
        "Known parent is #{found_barcodes.first}."
      else
        "Known parents are #{found_barcodes.join(', ')}"
      end
    record.errors[:base] <<
      "Invalid source plate layout: #{source_barcode} " \
        "is not a parent of #{destination_barcode}. #{parent_error}"
    false
  end
end

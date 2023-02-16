# frozen_string_literal: true

class Verification::Validator::SourceAndDestinationPlatesScanned < ActiveModel::Validator
  def validate(record) # rubocop:todo Metrics/MethodLength
    record
      .parse_source_and_destination_barcodes(record.scanned_values)
      .each do |source_barcode, destination_barcode|
        if destination_barcode.blank?
          record.errors.add(:base, "Invalid destination plate layout")
          break
        end

        if source_barcode.blank?
          record.errors.add(:base, "Invalid source plate layout")
          break
        end
      end
  end
end

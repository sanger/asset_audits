# frozen_string_literal: true

class Verification::Validator::PlatesScanned < ActiveModel::Validator
  def validate(record)
    if record.parse_source_and_destination_barcodes(record.scanned_values).flatten.empty?
      record.errors[:base] << 'No plates scanned'
    end
  end
end

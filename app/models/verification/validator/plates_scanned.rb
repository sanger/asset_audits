# frozen_string_literal: true

class Verification::Validator::PlatesScanned < ActiveModel::Validator
  def validate(record)
    # rubocop:todo Style/GuardClause
    if record.parse_source_and_destination_barcodes(record.scanned_values).flatten.empty?
      # rubocop:enable Style/GuardClause
      record.errors.add(:base, 'No plates scanned')
    end
  end
end

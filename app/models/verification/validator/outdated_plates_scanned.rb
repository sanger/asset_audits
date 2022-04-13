# frozen_string_literal: true

class Verification::Validator::OutdatedPlatesScanned < ActiveModel::Validator
  # rubocop:todo Metrics/MethodLength
  def validate(record) # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    plates = record.plates_from_barcodes(record.scanned_values)
    plates.each do |barcode, plate|
      if plate.nil?
        record.errors.add(:error, "The plate #{barcode} hasn't been found")
        next
      end
      if plate.purpose.lifespan.nil?
        record.errors.add(:error, "The plate #{barcode} can't be destroyed because it's a #{plate.purpose.name}")
        next
      end
      next unless plate.created_at > plate.purpose.lifespan.days.ago
      record.errors.add(:error, "The plate #{barcode} is less than #{plate.purpose.lifespan} days old")
      next
    end
    record.errors.add(:base, 'No plates found') if plates.empty?
  end
  # rubocop:enable Metrics/MethodLength
end

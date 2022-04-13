# frozen_string_literal: true

class Verification::Validator::OutdatedPlatesScanned < ActiveModel::Validator
  # rubocop:todo Metrics/MethodLength
  def validate(record) # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    labware = record.labware_from_barcodes(record.scanned_values)
    labware.each do |barcode, plate|
      if plate.nil?
        record.errors.add(:error, "The labware #{barcode} hasn't been found")
        next
      end
      if plate.purpose.lifespan.nil?
        record.errors.add(:error, "The labware #{barcode} can't be destroyed because it's a #{plate.purpose.name}")
        next
      end
      next unless plate.created_at > plate.purpose.lifespan.days.ago
      record.errors.add(:error, "The labware #{barcode} is less than #{plate.purpose.lifespan} days old")
      next
    end
    record.errors.add(:base, 'No labware found') if labware.empty?
  end
  # rubocop:enable Metrics/MethodLength
end

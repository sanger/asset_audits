# frozen_string_literal: true

class Verification::Validator::BedsAndPlatesScanned < ActiveModel::Validator
  def validate(record)
    record.scanned_values.each do |bed_name, position|
      unless valid_bed?(bed_name, position[:bed], position[:plate], record)
        record.errors.add(:base, "Invalid layout")
        break
      end
    end
  end

  private

  def valid_bed?(bed_name, bed_barcode, plate_barcode, record) # rubocop:todo Metrics/CyclomaticComplexity
    return true if bed_barcode.blank? && plate_barcode.blank?

    if bed_barcode.present? && plate_barcode.present?
      # rubocop:todo Lint/ShadowingOuterLocalVariable
      bed = record.instrument.beds.detect { |bed| bed.name.downcase.to_s == bed_name.to_s }

      # rubocop:enable Lint/ShadowingOuterLocalVariable
      return false if bed.nil?
      return false if bed.barcode != bed_barcode

      return true
    end

    false
  end
end

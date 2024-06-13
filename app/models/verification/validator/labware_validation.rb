# frozen_string_literal: true
module Verification::Validator::LabwareValidation
  # rubocop:todo Metrics/MethodLength
  def validate_labware_list(record, labware_list) # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
     labware_list.each do |barcode, labw|
      if labw.nil?
        record.errors.add(:error, "The labware #{barcode} hasn't been found")
        next
      end
      if labw.purpose.lifespan.nil?
        record.errors.add(:error, "The labware #{barcode} can't be destroyed because it's a #{labw.purpose.name}")
        next
      end
      next unless labw.created_at > labw.purpose.lifespan.days.ago
      record.errors.add(:error, "The labware #{barcode} is less than #{labw.purpose.lifespan} days old")
      next
    end
    record.errors.add(:base, "No labware found") if labware_list.empty?
  end
  # rubocop:enable Metrics/MethodLength
end
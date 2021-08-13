# frozen_string_literal: true

class Verification::Validator::AllDestinationPlatesScanned < ActiveModel::Validator
  def validate(record)
    return unless record.destination_beds.any? { |destination_bed| record.scanned_values[destination_bed.downcase.to_sym][:plate].blank? }

    record.errors[:base] << 'All destination plates must be scanned'
  end
end

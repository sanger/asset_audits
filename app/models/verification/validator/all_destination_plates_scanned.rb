# frozen_string_literal: true
class Verification::Validator::AllDestinationPlatesScanned < ActiveModel::Validator
  def validate(record)
    record.destination_beds.each do |destination_bed|
      if record.scanned_values[destination_bed.downcase.to_sym][:plate].blank?
        record.errors[:base] << 'All destination plates must be scanned'
        return
      end
    end
  end
end

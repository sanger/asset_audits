# frozen_string_literal: true

class Verification::Validator::AllDestinationPlatesScanned < ActiveModel::Validator
  def validate(record)
    # rubocop:disable Style/BlockDelimiters
    unless record.destination_beds.any? { |destination_bed|
             record.scanned_values[destination_bed.downcase.to_sym][:plate].blank?
           }
      return
    end
    # rubocop:enable Style/BlockDelimiters

    record.errors.add(:base, "All destination plates must be scanned")
  end
end

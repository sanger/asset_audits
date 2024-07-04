# frozen_string_literal: true
module Verification::Validator::LabwareValidation
  # rubocop:todo Metrics/MethodLength

  ERRORS_PREFIX = "No labware has been destroyed."

  def validate_labware_list(record, labware_list) # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    if labware_list.blank?
      record.errors.add(:base, "No labware found")
      return
    end

    labware_list.each do |barcode, labw|
      if labw.nil?
        add_errors_for_labware_with_prefix(record, "The labware #{barcode} hasn't been found")
        next
      end
      if labw.purpose.lifespan.nil?
        add_errors_for_labware_with_prefix(
          record,
          "The labware #{barcode} can't be destroyed because it's a #{labw.purpose.name}"
        )
        next
      end
      next unless labw.created_at > labw.purpose.lifespan.days.ago
      add_errors_for_labware_with_prefix(
        record,
        "The labware #{barcode} is less than #{labw.purpose.lifespan} days old"
      )
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  # Prefixes all error messages with ERRORS_PREFIX. The prefix is added only
  # once to the beginning of all the error messages.
  #
  # @params record [ActiveRecord::Base] The record (a verification instance) to add the error to.
  # @params message [String] The error message to add to the record.
  def add_errors_for_labware_with_prefix(record, message)
    message = "#{ERRORS_PREFIX} #{message}" if record.errors.empty?
    record.errors.add(:error, message)
  end
end

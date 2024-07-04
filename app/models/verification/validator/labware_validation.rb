# frozen_string_literal: true
module Verification::Validator::LabwareValidation
  ERRORS_PREFIX = "No labware can be destroyed."
  NO_LABWARE_FOUND = "No labware found"
  LABWARE_NOT_FOUND = "The labware %s hasn't been found"
  LABWARE_PURPOSE_ERROR = "The labware %s can't be destroyed because it's a %s"
  LABWARE_LIFESPAN_ERROR = "The labware %s is less than %s days old"

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def validate_labware_list(record, labware_list)
    if labware_list.blank?
      record.errors.add(:base, NO_LABWARE_FOUND)
      return
    end

    labware_list.each do |barcode, labw|
      if labw.nil?
        add_errors_for_labware_with_prefix(record, format(LABWARE_NOT_FOUND, barcode))
      elsif labw.purpose.lifespan.nil?
        add_errors_for_labware_with_prefix(record, format(LABWARE_PURPOSE_ERROR, barcode, labw.purpose.name))
        next
      elsif labw.created_at > labw.purpose.lifespan.days.ago
        add_errors_for_labware_with_prefix(record, format(LABWARE_LIFESPAN_ERROR, barcode, labw.purpose.lifespan))
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

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

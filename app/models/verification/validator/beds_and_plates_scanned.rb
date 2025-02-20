# frozen_string_literal: true

class Verification::Validator::BedsAndPlatesScanned < ActiveModel::Validator
  # Validates the scanned values of the verification record. It checks if the
  # bed exists for the instrument and the bed barcode matches the one specified
  # in the input.
  #
  # @param record [Verification::Base] the record to validate
  # @return [void]
  def validate(record)
    record.scanned_values.each do |bed_name, position|
      next if blank_position?(position)
      bed = find_bed(record, bed_name)
      break unless bed_found(record, bed_name, position, bed)
      break unless correct_bed(record, bed_name, position, bed)
    end
  end

  private

  # Checks if the position is blank, i.e. both bed and plate barcodes are nil.
  # This can happen if the user did not scan anything for this position. This
  # is used for skipping the validation of empty positions.
  #
  # @param position [Hash] the input that contains the bed and plate barcodes
  # @return [Boolean] true if the position is blank, false otherwise
  def blank_position?(position)
    position[:bed].blank? && position[:plate].blank?
  end

  # Finds the bed of the instrument specified by name, e.g. 'P2'.
  #
  # @param record [Verification::Base] the record to validate
  # @param bed_name [String] the name of the bed to find
  # @return [Bed, nil] the bed if found, nil otherwise
  def find_bed(record, bed_name)
    record.instrument.beds.detect { |bed| bed.name.downcase.to_s == bed_name.to_s }
  end

  # Adds an error to the verification record if the bed was not found. This can
  # happen if there is no bed with such name for the instrument.
  #
  # @param record [Verification::Base] the record to add the error to
  # @param bed_name [String] the name of the bed, e.g. 'p2'
  # @param position [Hash] the input that contains the bed and plate barcodes
  # @param bed [Bed] the bed looked up by the bed name
  # @return [Boolean] true if the bed was found, false otherwise
  def bed_found(record, bed_name, _position, bed)
    return true unless bed.nil?
    record.errors.add(:base, "Unknown bed: #{bed_name.upcase}")
    false
  end

  # Adds an error to the verification record if the bed barcode does not match
  # the one specified in the input.
  #
  # @param record [Verification::Base] the record to add the error to
  # @param bed_name [String] the name of the bed, e.g. 'p2'
  # @param position [Hash] the input that contains the bed and plate barcodes
  # @param bed [Bed] the bed looked up by the bed name
  # @return [Boolean] true if the bed barcode is correct, false otherwise
  def correct_bed(record, bed_name, position, bed)
    return true if bed.barcode == position[:bed]
    barcode = position[:bed].presence || "empty"
    record.errors.add(
      :base,
      "Invalid bed barcode for #{bed_name.upcase}: Expected #{bed.barcode}, but found #{barcode}."
    )
    false
  end
end

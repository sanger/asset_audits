# frozen_string_literal: true

class Verification::Validator::GroupableComplete < ActiveModel::Validator
  def validate(record)
    record.class.transfer_groups.all? { |t| is_transfer_valid?(t, record) }
  end

  def is_transfer_valid?(transfer, record) # rubocop:todo Naming/PredicateName
    scanned_values = record.scanned_values
    return true if is_transfer_complete?(transfer, scanned_values) || is_transfer_empty?(transfer, scanned_values)

    beds = transfer_bed_names(transfer).join(", ")
    record.errors.add(:base, "Invalid: All fields for beds #{beds} should be either filled in, or left blank")
    false
  end

  def is_transfer_complete?(transfer, scanned_values) # rubocop:todo Naming/PredicateName
    transfer_bed_names(transfer).all? do |bed|
      bed_barcode(scanned_values, bed).present? && plate_barcode(scanned_values, bed).present?
    end
  end

  def is_transfer_empty?(transfer, scanned_values) # rubocop:todo Naming/PredicateName
    transfer_bed_names(transfer).all? do |bed|
      bed_barcode(scanned_values, bed).blank? && plate_barcode(scanned_values, bed).blank?
    end
  end

  def bed_barcode(scanned_values, barcode)
    scanned_values[barcode.downcase.to_sym][:bed]
  end

  def plate_barcode(scanned_values, barcode)
    scanned_values[barcode.downcase.to_sym][:plate]
  end

  def transfer_bed_names(transfer)
    [transfer[:source_beds], transfer[:destination_beds]].flatten.uniq
  end
end

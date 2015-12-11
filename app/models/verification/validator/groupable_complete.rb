class Verification::Validator::GroupableComplete < ActiveModel::Validator
  def validate(record)
    unless record.class.transfer_groups.all?{|t| is_transfer_valid?(t, record.scanned_values)}
      record.errors[:base] << "Invalid verification group is not complete"
      return
    end
  end

  def bed_barcode(scanned_values, barcode)
    scanned_values[barcode.downcase.to_sym][:bed]
  end

  def plate_barcode(scanned_values, barcode)
    scanned_values[barcode.downcase.to_sym][:plate]
  end

  def is_transfer_complete?(transfer, scanned_values)
    [transfer[:source_beds], transfer[:destination_beds]].flatten.uniq.all? do |bed|
      !(bed_barcode(scanned_values, bed).blank? || plate_barcode(scanned_values, bed).blank?)
    end
  end

  def is_transfer_empty?(transfer, scanned_values)
    [transfer[:source_beds], transfer[:destination_beds]].flatten.uniq.all? do |bed|
      bed_barcode(scanned_values, bed).blank? && plate_barcode(scanned_values, bed).blank?
    end
  end

  def is_transfer_valid?(transfer, scanned_values)
    is_transfer_complete?(transfer, scanned_values) || is_transfer_empty?(transfer, scanned_values)
  end
end

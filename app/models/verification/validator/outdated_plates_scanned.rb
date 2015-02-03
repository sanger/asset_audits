class Verification::Validator::OutdatedPlatesScanned < ActiveModel::Validator

  def add_message(facility, message)
    messages = {} if messages.nil?
    if messages[facility].nil?
      messages[facility]=[message]
    else
      messages[facility].push(message)
    end
  end

  def validate(record)
    plates = record.plates_from_barcodes(record.scanned_values)
    record.plate_barcodes_to_destroy = []
    plates.keys.each do |barcode|
      plate = plates[barcode]
      if (plate.nil?)
        record.add_message(:error, "The barcode #{barcode} hasn't been found")
        next
      end
      if (plate.plate_purpose.lifespan == 0)
        record.add_message(:error, "The barcode #{barcode} can't be destroyed because its a #{plate.plate_purpose.name}")
        next
      end
      if (!plate.plate_purpose.lifespan.nil?) && (plate.plate_purpose.lifespan < 180)
        record.add_message(:error, "The barcode #{barcode} has less than 3 months of lifespan")
        next
      end
      record.plate_barcodes_to_destroy << barcode
      record.add_message(:notice, "The barcode #{barcode} is going to be processed for destroying")
    end
    if (record.plate_barcodes_to_destroy.length==0)
      record.errors.add(:base, "None of the barcodes check the conditions to be destroyed")
    end
  end

end

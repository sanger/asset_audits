class Verification::Validator::OutdatedPlatesScanned < ActiveModel::Validator
  def validate(record)
    plates = record.plates_from_barcodes(record.scanned_values)
    plates.keys.each do |barcode|
      plate = plates[barcode]
      if (plate.nil?)
        record.errors.add(:error, "The barcode #{barcode} hasn't been found")
        next
      end
      if (plate.plate_purpose.lifespan == 0)
        record.errors.add(:error, "The barcode #{barcode} can't be destroyed because its a #{plate.plate_purpose.name}")
        next
      end
      if (!plate.plate_purpose.lifespan.nil?) && (plate.plate_purpose.lifespan < 180)
        record.errors.add(:error, "The barcode #{barcode} has less than 3 months of lifespan")
        next
      end
    end
    if (plates.empty?)
      record.errors.add(:base, "None of the barcodes check the conditions to be destroyed")
    end
  end
end

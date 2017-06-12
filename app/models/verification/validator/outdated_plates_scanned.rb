class Verification::Validator::OutdatedPlatesScanned < ActiveModel::Validator
  def validate(record)
    plates = record.plates_from_barcodes(record.scanned_values)
    plates.each do |barcode, plate|
      if (plate.nil?)
        record.errors.add(:error, "The plate #{barcode} hasn't been found")
        next
      end
      if (plate.plate_purpose.lifespan.nil?)
        record.errors.add(:error, "The plate #{barcode} can't be destroyed because its a #{plate.plate_purpose.name}")
        next
      end
      if (plate.created_at > plate.plate_purpose.lifespan.days.ago)
        record.errors.add(:error, "The plate #{barcode} is less than #{plate.plate_purpose.lifespan} days old")
        next
      end
    end
    if (plates.empty?)
      record.errors.add(:base, 'No plates found')
    end
  end
end

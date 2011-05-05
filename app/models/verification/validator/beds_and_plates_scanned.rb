class Verification::Validator::BedsAndPlatesScanned < ActiveModel::Validator
  def validate(record)
    record.scanned_values.each do |bed_name, position|
      unless valid_bed?(bed_name, position[:bed], position[:plate], record)
        record.errors[:base] << "Invalid layout"
        return
      end
    end
  end
  
  private
  def valid_bed?(bed_name, bed_barcode, plate_barcode, record)
    return true if bed_barcode.blank? && plate_barcode.blank?
    if ( ! bed_barcode.blank? ) && ( ! plate_barcode.blank? )
      bed = record.instrument.beds.select{ |bed| bed.name.downcase.to_s == bed_name.to_s }.first
      return false if bed.nil?
      return false if bed.barcode != bed_barcode

      return true
    end

    false
  end

end

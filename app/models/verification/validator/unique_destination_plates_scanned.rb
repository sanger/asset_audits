class Verification::Validator::UniqueDestinationPlatesScanned < ActiveModel::Validator
  def validate(record)
    destination_barcodes = record.destination_beds.map{ |destination_bed| record.scanned_values[destination_bed.downcase.to_sym][:plate] }.select{ |barcode| ! barcode.blank? }
    if destination_barcodes != destination_barcodes.uniq
      record.errors[:base] << "Destination plate scanned more than once"
    end
  end
end

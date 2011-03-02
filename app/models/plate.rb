class Plate
  def self.sanger_barcodes(barcodes_string)
    return [] if barcodes_string.blank?
    split_barcodes(barcodes_string).map{ |barcode| Barcode.barcode_to_human(barcode) }
  end
   
  def self.split_barcodes(barcodes_string)
    barcodes_string.scan(/\d+/).map{ |plate| plate }
  end
end

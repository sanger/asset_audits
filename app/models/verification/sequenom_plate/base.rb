class Verification::SequenomPlate::Base < Verification::Base
  include Verification::BedVerification
  validates_with  Verification::Validator::SequenomPlateOrder
  validates_with  Verification::Validator::UniqueDestinationPlatesScanned
  
  def self.partial_name
    "dilution_plate"
  end
  
  def parse_source_and_destination_barcodes(scanned_values)
    source_and_destination_barcodes = []
    
    self.source_beds.each do |source_bed|
      source_barcode = scanned_values[source_bed.downcase.to_sym][:plate]
      next if source_barcode.blank?
      self.destination_beds.each do |destination_bed|
        destination_barcode = scanned_values[destination_bed.downcase.to_sym][:plate]
        next if destination_barcode.blank?
        source_and_destination_barcodes << [ source_barcode, destination_barcode]
      end
    end

    source_and_destination_barcodes
  end
  
end

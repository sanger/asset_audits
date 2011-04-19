class Verification::DilutionPlateVerification < Verification::Base
  include Verification::BedVerification
  self.source_beds      = ['P2','P5', 'P8', 'P11']
  self.destination_beds = ['P3','P6', 'P9', 'P12']

  def self.partial_name
    "dilution_plate"
  end
  
  def self.javascript_partial_name
    "dilution_plate_javascript"
  end

  def parse_source_and_destination_barcodes(scanned_values)
    source_and_destination_barcodes = []
    self.source_beds.each_with_index do |source_bed, index|
      source_barcode = scanned_values[source_bed.downcase.to_sym][:plate]
      destination_barcode = scanned_values[destination_beds[index].downcase.to_sym][:plate]
      next if source_barcode.blank? && destination_barcode.blank?
      source_and_destination_barcodes << [ source_barcode, destination_barcode ]
    end

    source_and_destination_barcodes
  end
  
end


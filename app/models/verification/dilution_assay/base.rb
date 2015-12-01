class Verification::DilutionAssay::Base < Verification::Base
  include Verification::BedVerification
  validates_with Verification::Validator::SourceAndDestinationPlatesScanned
  validates_with Verification::Validator::AllDestinationPlatesScanned

  def self.partial_name
    "dilution_assay"
  end

  def parse_source_and_destination_barcodes(scanned_values)
    source_and_destination_barcodes = []
    self.transfers.sort{|v| v[:priority] }.each do |transfer|
      transfer[:source_beds].each do |source_bed|
        source_barcode = scanned_values[source_bed.downcase.to_sym][:plate]
        unless source_barcode.nil?
          transfer[:destination_beds].each do |destination_bed|
            destination_barcode = scanned_values[destination_bed.downcase.to_sym][:plate]
            source_and_destination_barcodes << [ source_barcode, destination_barcode]
          end
        end
      end
    end
    source_and_destination_barcodes
  end
end

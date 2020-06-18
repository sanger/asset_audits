# frozen_string_literal: true

# Inherited by {Verification::AssayPlate::Fx} and {Verification::AssayPlate::Nx}
# Which configure the beds used.
# Validates the transfer of one source plate onto two destination plates.
#
# s1 --> d1
#   \--> d2
class Verification::AssayPlate::Base < Verification::Base
  include Verification::BedVerification
  validates_with Verification::Validator::SourceAndDestinationPlatesScanned
  validates_with Verification::Validator::AllDestinationPlatesScanned

  self.partial_name = 'assay_plate'
  self.javascript_partial_name = 'shared_robot_javascript'

  def self.ordered_beds
    source_beds + destination_beds
  end

  def self.column_groups
    ordered_beds.map { |b| [b] }
  end

  def parse_source_and_destination_barcodes(scanned_values)
    source_and_destination_barcodes = []
    source_barcode = scanned_values[source_beds.first.downcase.to_sym][:plate]
    return [] if source_barcode.blank?

    destination_beds.each do |destination_bed|
      destination_barcode = scanned_values[destination_bed.downcase.to_sym][:plate]
      next if destination_barcode.blank?
      source_and_destination_barcodes << [source_barcode, destination_barcode]
    end

    source_and_destination_barcodes
  end
end

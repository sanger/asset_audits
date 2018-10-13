# frozen_string_literal: true
class Verification::SequenomPlate::Base < Verification::Base
  include Verification::BedVerification
  validates_with  Verification::Validator::SequenomPlateOrder
  validates_with  Verification::Validator::UniqueDestinationPlatesScanned

  self.partial_name = 'dilution_plate'
  self.javascript_partial_name = 'shared_robot_javascript'

  def self.ordered_beds
    source_beds + destination_beds
  end

  # Column groups define highlighting, which Sequenom doesn't have.
  def self.column_groups
    []
  end

  def parse_source_and_destination_barcodes(scanned_values)
    source_and_destination_barcodes = []

    source_beds.each do |source_bed|
      source_barcode = scanned_values[source_bed.downcase.to_sym][:plate]
      next if source_barcode.blank?
      destination_beds.each do |destination_bed|
        destination_barcode = scanned_values[destination_bed.downcase.to_sym][:plate]
        next if destination_barcode.blank?
        source_and_destination_barcodes << [source_barcode, destination_barcode]
      end
    end

    source_and_destination_barcodes
  end
end

# frozen_string_literal: true

# Inherited by {Verification::DilutionPlate::Bravo},
# {Verification::DilutionPlate::FX}, {Verification::DilutionPlate::NX},
# {Verification::DilutionPlate::Biorobot}, {Verification::DilutionPlate::QiagenBiorobot}
# {Verification::DilutionPlate::Hamilton} and {Verification::DilutionPlate::BravoLE}
# which configures the beds used.
# Validates the transfer of one or more source plates onto one destination plate
# each
#
# s1 --> d1   s2 --> d2   s3 --> d3
class Verification::DilutionPlate::Base < Verification::Base
  include Verification::BedVerification
  validates_with Verification::Validator::SourceAndDestinationPlatesScanned

  self.partial_name = 'dilution_plate'
  self.javascript_partial_name = 'shared_robot_javascript'

  def self.ordered_beds
    column_groups.flatten
  end

  def self.column_groups
    source_beds.zip(destination_beds)
  end

  def parse_source_and_destination_barcodes(scanned_values)
    source_and_destination_barcodes = []
    source_beds.each_with_index do |source_bed, index|
      source_barcode = scanned_values[source_bed.downcase.to_sym][:plate]
      destination_barcode = scanned_values[destination_beds[index].downcase.to_sym][:plate]
      next if source_barcode.blank? && destination_barcode.blank?

      source_and_destination_barcodes << [source_barcode, destination_barcode]
    end

    source_and_destination_barcodes
  end
end

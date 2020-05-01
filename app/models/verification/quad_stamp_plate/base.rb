# frozen_string_literal: true
class Verification::QuadStampPlate::Base < Verification::Base
  include Verification::BedVerification

  validates_with Verification::Validator::SourceAndDestinationPlatesScanned
  validates_with Verification::Validator::SourcesInCorrectQuadrants

  self.partial_name = 'quad_stamp_plate'
  self.javascript_partial_name = 'shared_robot_javascript'

  def self.ordered_beds
    column_groups.flatten
  end

  def self.column_groups
    source_beds.map do |source_bed|
      [source_bed, destination_beds.first]
    end
  end

  def parse_source_and_destination_barcodes(scanned_values)
    source_and_destination_barcodes = []

    source_beds.each_with_index do |source_bed, index|
      source_barcode = scanned_values[source_bed.downcase.to_sym][:plate]

      next if source_barcode.blank?
      source_and_destination_barcodes << [source_barcode, destination_barcode]
    end

    source_and_destination_barcodes
  end

  def source_and_destination_barcodes
    @source_and_destination_barcodes ||= parse_source_and_destination_barcodes(scanned_values)
  end

  def destination_barcode
    @destination_barcode ||= scanned_values[destination_beds.first.downcase.to_sym][:plate]
  end

  def quadrant_to_source_barcode
    return @quadrant_to_source_barcode if @quadrant_to_source_barcode

    quadrant_to_source_barcode_hash = {}
    source_beds.each_with_index do |source_bed, index|
      curr_quad = "Quadrant #{index + 1}"
      source_barcode = scanned_values[source_bed.downcase.to_sym][:plate]
      quadrant_to_source_barcode_hash[curr_quad] = source_barcode.present? ? source_barcode : 'Empty'
    end
    @quadrant_to_source_barcode = quadrant_to_source_barcode_hash
  end

  # def parse_source_and_destination_barcodes(scanned_values)
  #   source_and_destination_barcodes = []

  #   source_barcodes = {}
    # source_beds.each_with_index do |source_bed, index|
    #   curr_quad = "quad_#{index}"
    #   source_barcode = scanned_values[source_beds[index].downcase.to_sym][:plate]
    #   source_barcodes[curr_quad] = source_barcode.present? source_barcode : nil
    # end

  #   destination_barcode = scanned_values[destination_beds.first.downcase.to_sym][:plate]

  #   source_and_destination_barcodes << [source_barcodes, destination_barcode]

  #   source_and_destination_barcodes
  # end
end

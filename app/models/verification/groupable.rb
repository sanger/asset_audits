# frozen_string_literal: true

module Verification::Groupable
  # Returns pairs of source and destination barcodes, e.g.
  # [
  #   [source_barcode_1, dest_barcode_1],
  #   [source_barcode_2, dest_barcode_2],
  #   [source_barcode_3, dest_barcode_3]
  # ]
  #
  # rubocop:todo Metrics/MethodLength
  def parse_source_and_destination_barcodes(scanned_values) # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    source_and_destination_barcodes = []
    self
      .class
      .transfers
      .sort_by { |a| a[:priority] }
      .each do |transfer|
        transfer[:source_beds].each do |source_bed|
          source_barcode = scanned_values[source_bed.downcase.to_sym][:plate]
          bed_barcode = scanned_values[source_bed.downcase.to_sym][:bed] # rubocop:todo Lint/UselessAssignment
          next if source_barcode.blank?

          transfer[:destination_beds].each do |destination_bed|
            destination_barcode = scanned_values[destination_bed.downcase.to_sym][:plate]
            source_and_destination_barcodes << [source_barcode, destination_barcode]
          end
        end
      end
    source_and_destination_barcodes
  end

  # rubocop:enable Metrics/MethodLength

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      self.partial_name = 'groupable_assets'
      self.javascript_partial_name = 'groupable_javascript'
      validates_with Verification::Validator::GroupableComplete
    end
  end

  module ClassMethods
    def destination_beds
      transfer_groups.pluck(:destination_beds).flatten.uniq
    end

    def source_beds
      transfer_groups.pluck(:source_beds).flatten.uniq
    end

    # rubocop:todo Metrics/AbcSize
    # rubocop:todo Metrics/MethodLength
    def transfer_groups # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
      transfers
        .pluck(:group)
        .uniq
        .map do |group_id|
          transfers_of_group = transfers.select { |t| t[:group] == group_id }
          destination_beds = transfers_of_group.pluck(:destination_beds).flatten.uniq
          transfers_of_group.each_with_object(
            { group: group_id, source_beds: [], destination_beds: destination_beds }
          ) do |transfer, memo|
            transfer[:source_beds].each do |source_bed|
              memo[:source_beds] << source_bed unless memo[:destination_beds].include?(source_bed)
            end
          end
        end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end

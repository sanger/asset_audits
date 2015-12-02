module Verification::Groupable

  def parse_source_and_destination_barcodes(scanned_values)
    source_and_destination_barcodes = []
    self.class.transfers.sort{|a,b| a[:priority] <=> b[:priority] }.each do |transfer|
      transfer[:source_beds].each do |source_bed|
        source_barcode = scanned_values[source_bed.downcase.to_sym][:plate]
        unless source_barcode.blank?
          transfer[:destination_beds].each do |destination_bed|
            destination_barcode = scanned_values[destination_bed.downcase.to_sym][:plate]
            source_and_destination_barcodes << [ source_barcode, destination_barcode]
          end
        end
      end
    end
    source_and_destination_barcodes
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def destination_beds
      transfer_groups.map{|g| g[:destination_beds]}.flatten.uniq
    end

    def source_beds
      transfer_groups.map{|g| g[:source_beds]}.flatten.uniq
    end

    def transfer_groups
      transfers.map{|t| t[:group] }.uniq.map do|group_id|
        transfers_of_group = transfers.select{|t| t[:group]==group_id}

        transfers_of_group.reduce({
          :group => group_id,
          :source_beds => [],
          :destination_beds => transfers_of_group.map{|t| t[:destination_beds]}.flatten.uniq
        }) do |memo, transfer|
          transfer[:source_beds].each do |source_bed|
            memo[:source_beds] << source_bed unless memo[:destination_beds].include?(source_bed)
          end
          memo
        end
      end
    end

    def javascript_partial_name
      "groupable_javascript"
    end

    def partial_name
      "groupable_assets"
    end
  end

end

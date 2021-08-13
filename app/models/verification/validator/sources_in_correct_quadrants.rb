# frozen_string_literal: true

class Verification::Validator::SourcesInCorrectQuadrants < ActiveModel::Validator
  def validate(record)
    destination_plate = Sequencescape::Api::V2::Plate.where(barcode: record.destination_barcode).first
    if destination_plate.nil?
      record.errors[:base] << 'Couldn\'t find the destination plate.'
      return
    end

    if destination_plate.size != 384
      record.errors[:base] << 'The destination plate should have 384 wells.'
      return
    end

    if missing_custom_metadatum_collection?(destination_plate)
      record.errors[:base] << 'The destination plate doesn\'t have any quadrant information. ' \
                              'Was it made by a quadrant stamp?'
      return
    end

    validate_quadrants(record, destination_plate)
  end

  def validate_quadrants(record, destination_plate)
    (1..4).each do |index|
      quadrant_name = "Quadrant #{index}"
      quad_metadata = destination_plate.custom_metadatum_collection.metadata[quadrant_name]
      if quad_metadata.nil?
        record.errors[:base] << "The destination plate doesn\'t have any information for quadrant #{index}"
        break
      end

      quad_scanned = record.quadrant_to_source_barcode[quadrant_name]
      next if quad_scanned == quad_metadata

      bed = record.source_beds[index - 1]
      record.errors[:base] << "The barcode in bed #{bed} doesn\'t match the plate in " \
                              "#{quadrant_name} on the destination plate."
      break
    end
  end

  def missing_custom_metadatum_collection?(plate)
    plate.custom_metadatum_collection.nil? || plate.custom_metadatum_collection.metadata.nil?
  end
end

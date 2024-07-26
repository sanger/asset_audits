# frozen_string_literal: true

# This class is used for both plates and tubes.
class ProcessLabware < ProcessPlate
  def asset_uuids_from_plate_barcodes
    Sequencescape::Api::V2::Labware.where(barcode: barcodes).map(&:uuid)
  end
end

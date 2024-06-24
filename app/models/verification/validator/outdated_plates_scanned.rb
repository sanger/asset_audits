# frozen_string_literal: true

class Verification::Validator::OutdatedPlatesScanned < ActiveModel::Validator
  include Verification::Validator::LabwareValidation
  def validate(record)
    labware_list = record.labware_from_barcodes(record.scanned_values)
    validate_labware_list(record, labware_list)
  end
end

# frozen_string_literal: true
class Verification::Validator::DestroyLocationScanned < ActiveModel::Validator
 include Verification::Validator::LabwareValidation
    def validate(record)
      labware_list = record.labware_from_location(record.scanned_values)
      
      return if labware_list.blank?
      validate_labware_list(record, labware_list)
    end
end

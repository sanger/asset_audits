module PostAuditActions::SubstractionVolumeForWorkingDilution
  def self.included(base)
    base.handle_asynchronously :substract_volume_because_of_working_dilution!
  end

  def substract_volumes(source_plates)
    substract_volume_because_of_working_dilution! if needs_to_substract_volume?
  end

  def needs_to_substract_volume?
    !instrument_process.substracted_volume_on_process.nil?
  end

  def substract_volume_because_of_working_dilution!
    ActiveRecord::Base.transaction do
      if needs_to_substract_volume?
        asset_uuids_from_plate_barcodes.each do |asset_uuid|
          decrease_volume = instrument_process.substracted_volume_on_process
          api.plate.find(asset_uuid).substract_volume!(decrease_volume)
        end
      end
    end
  end

end

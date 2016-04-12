module PostAuditActions::SubstractionVolumeForWorkingDilution
  def self.included(base)
    base.handle_asynchronously :substract_volume_because_of_working_dilution!
  end

  def substract_volumes
    substract_volume_because_of_working_dilution! if needs_to_substract_volume?
  end

  def needs_to_substract_volume?
    !Settings.nil? && !Settings.update_volume_for_instrument_process_key.nil? &&
    !Settings.update_volume_for_instrument_process_key[instrument_process.key.downcase].nil?
  end

  def destination_plates_uuids_to_substract
    asset_uuids_from_plate_barcodes.each_with_index.map{|uuid, pos| uuid if pos.odd? }.compact
  end

  def substract_volume_because_of_working_dilution!
    ActiveRecord::Base.transaction do
      if needs_to_substract_volume?
        destination_plates_uuids_to_substract.each do |asset_uuid|
          decrease_volume = Settings.update_volume_for_instrument_process_key[instrument_process.key.downcase]
          api.plate.find(asset_uuid).volume_updates.create!(:volume_change => decrease_volume, :created_by => user_login)
        end
      end
    end
  end

end

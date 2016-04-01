module PostAuditActions::SubstractionVolumeForWorkingDilution
  def self.included(base)
    base.handle_asynchronously :substract_volume_because_of_working_dilution!
  end

  def post_audit_actions!
    substract_volume_because_of_working_dilution! if needs_to_substract_volume?
  end

  def needs_to_substract_volume?
    hash = Settings.decrease_volume_for_instrument_process_name
    !hash.nil? && ! hash[instrument_process.name.downcase].nil?
  end

  def substract_volume_because_of_working_dilution!
    ActiveRecord::Base.transaction do
      asset_uuid = asset_uuids_from_plate_barcodes.first
      if needs_to_substract_volume?
        decrease_volume = Settings.decrease_volume_for_instrument_process_name[instrument_process.name.downcase]
        api.plate.find(asset_uuid).substract_volume!(decrease_volume)
      end
    end
  end

end

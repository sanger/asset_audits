# frozen_string_literal: true

module PostAuditActions::SubtractionVolumeForWorkingDilution
  def self.included(base)
    base.handle_asynchronously :subtract_volume_because_of_working_dilution!
  end

  def subtract_volumes
    subtract_volume_because_of_working_dilution! if needs_to_subtract_volume?
  end

  def needs_to_subtract_volume?
    !instrument_process.volume_to_pick.nil?
  end

  def source_plates_uuids_to_subtract
    asset_uuids_from_plate_barcodes.each_with_index.filter_map { |uuid, pos| uuid if pos.even? }
  end

  def subtract_volume_because_of_working_dilution!
    ActiveRecord::Base.transaction do
      if needs_to_subtract_volume?
        source_plates_uuids_to_subtract.each do |asset_uuid|
          decrease_volume = -1 * instrument_process.volume_to_pick
          Sequencescape::Api::V2::VolumeUpdate.create!(target_uuid: asset_uuid, volume_change: decrease_volume, created_by: user_login)
        end
      end
    end
  end
end

class AddWdVolumeDecrease < ActiveRecord::Migration
  def self.wd_keys
    ["slf_working_dilution", "wd_and_pico_assay", "x2_wd_and_pico_assay"]
  end
  def self.up
    self.wd_keys.each do |key|
      InstrumentProcess.find_by_key!(key).update_attributes!({
        :substracted_volume_on_process => 20
      })
    end
  end

  def self.down
    self.wd_keys.each do |key|
      InstrumentProcess.find_by_key!(key).update_attributes!({
        :substracted_volume_on_process => nil
      })
    end
  end
end

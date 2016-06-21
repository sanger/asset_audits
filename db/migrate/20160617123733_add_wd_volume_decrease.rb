class AddWdVolumeDecrease < ActiveRecord::Migration
  def self.wd_keys
    ["slf_working_dilution", "wd_and_pico_assay", "x2_wd_and_pico_assay"]
  end
  def self.up
    self.wd_keys.each do |key|
      InstrumentProcess.find_by_key!(key).update_attributes!({
        :volume_to_pick => 2
      })
    end
  end

  def self.down
    self.wd_keys.each do |key|
      InstrumentProcess.find_by_key!(key).update_attributes!({
        :volume_to_pick => nil
      })
    end
  end
end

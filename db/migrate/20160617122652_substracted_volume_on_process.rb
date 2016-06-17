class SubstractedVolumeOnProcess < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      add_column :instrument_processes, :substracted_volume_on_process, :float, :default => nil
    end
  end
  def self.down
    ActiveRecord::Base.transaction do
      remove_column :instrument_processes, :substracted_volume_on_process
    end
  end

end

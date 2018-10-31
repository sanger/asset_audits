class SubstractedVolumeOnProcess < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      add_column :instrument_processes, :volume_to_pick, :float, default: nil
    end
  end
  def self.down
    ActiveRecord::Base.transaction do
      remove_column :instrument_processes, :volume_to_pick
    end
  end
end

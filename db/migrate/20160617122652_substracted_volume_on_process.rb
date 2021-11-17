# frozen_string_literal: true

class SubstractedVolumeOnProcess < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction { add_column :instrument_processes, :volume_to_pick, :float, default: nil }
  end

  def self.down
    ActiveRecord::Base.transaction { remove_column :instrument_processes, :volume_to_pick }
  end
end

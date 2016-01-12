class AddVisualCheckToProcessPlates < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      add_column :process_plates, :visual_check, :boolean, :default => false
      add_column :instrument_processes, :visual_check_required, :boolean, :default => false
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      remove_column :process_plates, :visual_check
      remove_column :instrument_processes, :visual_check_required
    end
  end
end

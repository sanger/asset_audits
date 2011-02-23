class AddKeyToProcess < ActiveRecord::Migration
  def self.up
    add_column :instrument_processes, :key, :string
    add_index :instrument_processes, :key
  end

  def self.down
    remove_column :instrument_processes, :key
  end
end
class AddInstrumentProcessTable < ActiveRecord::Migration
  def self.up
    create_table :instrument_processes, force: true do |t|
      t.string :name
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :instrument_processes
  end
end

# frozen_string_literal: true

class AddInstrumentTable < ActiveRecord::Migration
  def self.up
    create_table :instruments, force: true do |t|
      t.string :name
      t.timestamps
    end

    create_table :instrument_processes_instruments, force: true do |t|
      t.integer :instrument_id
      t.integer :instrument_process_id
      t.timestamps
    end
    add_index :instrument_processes_instruments, :instrument_id, name: 'ipi_i'
    add_index :instrument_processes_instruments, :instrument_process_id, name: 'ipi_ip'
  end

  def self.down
    drop_table :instrument_processes_instruments
    drop_table :instruments
  end
end

# frozen_string_literal: true

class AddInstrumentProcessTable < ActiveRecord::Migration
  def self.up
    create_table :instrument_processes, force: true do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :instrument_processes
  end
end

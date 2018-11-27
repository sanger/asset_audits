# frozen_string_literal: true
class AddProcessPlateTable < ActiveRecord::Migration
  def self.up
    create_table :process_plates, force: true do |t|
      t.string :user_barcode
      t.string :instrument_barcode
      t.string :source_plates
      t.integer :instrument_process_id
      t.timestamps
    end
  end

  def self.down
    drop_table :process_plates
  end
end

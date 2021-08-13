# frozen_string_literal: true

class AddBarcodeColumnToInstrument < ActiveRecord::Migration
  def self.up
    add_column :instruments, :barcode, :string
    add_index :instruments, :barcode
  end

  def self.down
    remove_column :instruments, :barcode
  end
end

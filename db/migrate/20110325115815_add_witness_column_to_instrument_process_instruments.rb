class AddWitnessColumnToInstrumentProcessInstruments < ActiveRecord::Migration
  def self.up
    add_column :instrument_processes_instruments, :witness, :boolean
    add_column :process_plates, :witness_barcode, :string
  end

  def self.down
    remove_column :instrument_processes_instruments, :witness
    remove_column :process_plates, :witness_barcode, :string
  end
end
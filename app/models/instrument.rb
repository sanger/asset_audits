# frozen_string_literal: true
class Instrument < ActiveRecord::Base
  has_many :instrument_processes_instruments, dependent: :destroy
  has_many :instrument_processes, through: :instrument_processes_instruments
  has_many :beds, dependent: :destroy

  validates_uniqueness_of :name, message: 'must be unique'
  validates_uniqueness_of :barcode, message: 'must be unique'
  validates_presence_of :name, message: "can't be blank"
  validates_presence_of :barcode, message: "can't be blank"

  def self.processes_from_instrument_barcode(barcode)
    instrument = find_by_barcode(barcode)
    return instrument.instrument_processes if instrument && !instrument.instrument_processes.empty?

    InstrumentProcess.sorted_by_name
  end
end

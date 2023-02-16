# frozen_string_literal: true

class Instrument < ApplicationRecord
  has_many :instrument_processes_instruments, dependent: :destroy
  has_many :instrument_processes, through: :instrument_processes_instruments
  has_many :beds, dependent: :destroy

  validates :name, uniqueness: { message: 'must be unique' } # rubocop:todo Rails/UniqueValidationWithoutIndex
  validates :barcode, uniqueness: { message: 'must be unique' } # rubocop:todo Rails/UniqueValidationWithoutIndex
  validates :name, presence: { message: "can't be blank" }
  validates :barcode, presence: { message: "can't be blank" }

  def self.processes_from_instrument_barcode(barcode)
    instrument = find_by(barcode:)
    return instrument.instrument_processes if instrument && !instrument.instrument_processes.empty?

    InstrumentProcess.sorted_by_name
  end
end

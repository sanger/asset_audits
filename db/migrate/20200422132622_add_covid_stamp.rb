# frozen_string_literal: true
class AddCovidStamp < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      instrument = Instrument.find_or_create_by!(name: 'Beckman NX', barcode: '009851')
      instrument_process = InstrumentProcess.create!(name: 'COVID stamp', key: 'covid_stamp')
      InstrumentProcessesInstrument.create!(
        instrument: instrument,
        instrument_process: instrument_process,
        bed_verification_type: 'Verification::DilutionPlate::Nx'
      )
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      instrument_process = InstrumentProcess.find_by_key('covid_stamp')
      instrument_processes_instruments = instrument_process.instrument_processes_instruments
      instrument_processes_instruments.each(&:destroy!)
      instrument_process.destroy!
    end
  end
end

# frozen_string_literal: true

namespace :covid_stamp do
  task add: :environment do # rubocop:todo Rake/Desc
    ActiveRecord::Base.transaction do
      instrument = Instrument.find_or_create_by!(name: 'Beckman NX', barcode: '009851')
      instrument_process = InstrumentProcess.create!(name: 'COVID 96 Well STAMP', key: 'covid_stamp')
      InstrumentProcessesInstrument.create!(
        instrument:,
        instrument_process:,
        bed_verification_type: 'Verification::DilutionPlate::Nx'
      )
    end
  end

  task remove: :environment do # rubocop:todo Rake/Desc
    ActiveRecord::Base.transaction do
      instrument_process = InstrumentProcess.find_by(key: 'covid_stamp')
      instrument_processes_instruments = instrument_process.instrument_processes_instruments
      instrument_processes_instruments.each(&:destroy!)
      instrument_process.destroy!
    end
  end
end

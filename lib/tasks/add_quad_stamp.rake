# frozen_string_literal: true

namespace :quad_stamp do
  task add: :environment do
    ActiveRecord::Base.transaction do
      instrument_nx = Instrument.find_or_create_by!(name: 'Beckman NX', barcode: '009851')
      instrument_process = InstrumentProcess.create!(name: '384 Quadrant STAMP', key: 'quad_stamp')
      InstrumentProcessesInstrument.create!(
        instrument: instrument_nx,
        instrument_process: instrument_process,
        bed_verification_type: 'Verification::QuadStampPlate::Nx'
      )

      instrument_brv = Instrument.find_or_create_by!(name: 'Bravo', barcode: '4880000059873')
      InstrumentProcessesInstrument.create!(
        instrument: instrument_brv,
        instrument_process: instrument_process,
        bed_verification_type: 'Verification::QuadStampPlate::Bravo'
      )
    end
  end

  task remove: :environment do
    ActiveRecord::Base.transaction do
      instrument_process = InstrumentProcess.find_by_key('quad_stamp')
      instrument_processes_instruments = instrument_process.instrument_processes_instruments
      instrument_processes_instruments.each(&:destroy!)
      instrument_process.destroy!
    end
  end
end

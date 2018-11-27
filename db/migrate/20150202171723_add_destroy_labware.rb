# frozen_string_literal: true
class AddDestroyLabware < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      instrument = Instrument.create ({ name: 'Destroying instrument', barcode: '6720000011694' })
      instrument_process = InstrumentProcess.create ({ name: 'Destroying labware', key: 'destroy_labware',
                                                       request_instrument: false })
      instrument_processes_instrument = InstrumentProcessesInstrument.create(
        instrument: instrument,
        instrument_process: instrument_process,
        bed_verification_type: 'Verification::OutdatedLabware::Base'
      )
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      instrument = Instrument.find_by_barcode('destroying-instrument')
      instrument.instrument_processes_instruments.each(&:destroy)
      instrument.destroy
      InstrumentProcess.find_by_key('destroy_labware').destroy
    end
  end
end

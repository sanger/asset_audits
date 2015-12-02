class DilutionAndPicoAssay < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      instrument = Instrument.find_by_name!("Beckman NX")
      instrument_process = InstrumentProcess.create ({:name => "Working Dilution and Pico Assay", :key => "wd_and_pico_assay"})
      instrument_process_2 = InstrumentProcess.create ({:name => "Working Dilution and Pico Assay (x2)", :key => "x2_wd_and_pico_assay"})
      instrument_processes_instrument = InstrumentProcessesInstrument.create ({:instrument => instrument,
        :instrument_process => instrument_process, :bed_verification_type => "Verification::DilutionAssay::Nx"})
      instrument_processes_instrument2 = InstrumentProcessesInstrument.create ({:instrument => instrument,
        :instrument_process => instrument_process_2, :bed_verification_type => "Verification::DilutionAssay::NxGroup"})
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      instrument = Instrument.find_by_name!("Beckman NX")
      ["wd_and_pico_assay", "x2_wd_and_pico_assay"].each do |instrument_process_name|
        instrument_process = InstrumentProcess.find_by_key(instrument_process_name)
        instrument.instrument_processes_instruments.each do |ip|
          ip.destroy if ip.instrument_process == instrument_process
        end
        instrument_process.destroy
      end
    end
  end
end

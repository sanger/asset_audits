class Instrument < ActiveRecord::Base
  has_many :instrument_processes_instruments
  has_many :instrument_processes, :through => :instrument_processes_instruments
  
  
  def self.processes_from_instrument_barcode(barcode)
    instrument = self.find_by_barcode(barcode)
    return instrument.instrument_processes if instrument && ! instrument.instrument_processes.empty?
    
    InstrumentProcess.sorted_by_name
  end
end

class InstrumentProcessesInstrument < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :instrument_process  
end

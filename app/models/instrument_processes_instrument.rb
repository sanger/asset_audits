class InstrumentProcessesInstrument < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :instrument_process  
  
  validates_presence_of :instrument, :message => "can't be blank"
  validates_presence_of :instrument_process, :message => "can't be blank"
  
  validates_uniqueness_of :instrument_id, :scope => [:instrument_process_id]
  
  
end

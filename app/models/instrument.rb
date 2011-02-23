class Instrument < ActiveRecord::Base
  has_many :instrument_processes_instruments
  has_many :instrument_processes, :through => :instrument_processes_instruments
  
end

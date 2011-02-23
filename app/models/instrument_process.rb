class InstrumentProcess < ActiveRecord::Base
  has_many :instrument_processes_instruments
  has_many :instruments, :through => :instrument_processes_instruments
end

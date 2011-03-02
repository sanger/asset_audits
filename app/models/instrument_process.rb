class InstrumentProcess < ActiveRecord::Base
  has_many :instrument_processes_instruments
  has_many :instruments, :through => :instrument_processes_instruments
  
  scope :sorted_by_name , :order => "name ASC"
end

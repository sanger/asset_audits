class InstrumentProcess < ActiveRecord::Base
  has_many :instrument_processes_instruments
  has_many :instruments, through: :instrument_processes_instruments

  scope :sorted_by_name, ->() { order(name: :ASC) }

  validates_format_of :key, with: /\A[\w_]+\z/i

  validates_uniqueness_of :name, message: 'must be unique'
  validates_uniqueness_of :key, message: 'must be unique'
  validates_presence_of :name, message: "can't be blank"
  validates_presence_of :key, message: "can't be blank"
end

class Bed < ActiveRecord::Base
  belongs_to :instrument

  validates_uniqueness_of :barcode, message: "must be unique"
  validates_uniqueness_of :name, scope: [:instrument_id]
  validates_uniqueness_of :bed_number, scope: [:instrument_id]
  validates_presence_of :name, message: "can't be blank"
  validates_presence_of :barcode, message: "can't be blank"
  validates_presence_of :bed_number, message: "can't be blank"
  validates_numericality_of :bed_number, only_integer: true, message: "can only be whole numbers."
  validates_inclusion_of :bed_number, in: 0..100, message: "can only be between 0 and 100."
end

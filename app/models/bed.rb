# frozen_string_literal: true

class Bed < ApplicationRecord
  belongs_to :instrument

  # rubocop:todo Rails/UniqueValidationWithoutIndex
  validates :barcode, uniqueness: { scope: [:instrument_id], message: "must be unique for an instrument" }

  # rubocop:enable Rails/UniqueValidationWithoutIndex
  validates :name, uniqueness: { scope: [:instrument_id] } # rubocop:todo Rails/UniqueValidationWithoutIndex
  validates :bed_number, uniqueness: { scope: [:instrument_id] } # rubocop:todo Rails/UniqueValidationWithoutIndex
  validates :name, presence: { message: "can't be blank" }
  validates :barcode, presence: { message: "can't be blank" }
  validates :bed_number, presence: { message: "can't be blank" }
  validates :bed_number, numericality: { only_integer: true, message: "can only be whole numbers." }
  validates :bed_number, inclusion: { in: 0..100, message: "can only be between 0 and 100." }
end

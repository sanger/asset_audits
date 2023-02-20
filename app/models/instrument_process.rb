# frozen_string_literal: true

class InstrumentProcess < ApplicationRecord
  has_many :instrument_processes_instruments # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :instruments, through: :instrument_processes_instruments

  scope :sorted_by_name, -> { order(name: :ASC) }

  validates :key, format: { with: /\A[\w_]+\z/i }

  validates :name, uniqueness: { message: "must be unique" } # rubocop:todo Rails/UniqueValidationWithoutIndex
  validates :key, uniqueness: { message: "must be unique" } # rubocop:todo Rails/UniqueValidationWithoutIndex
  validates :name, presence: { message: "can't be blank" }
  validates :key, presence: { message: "can't be blank" }
end

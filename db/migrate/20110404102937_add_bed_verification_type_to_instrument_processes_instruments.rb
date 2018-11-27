# frozen_string_literal: true
class AddBedVerificationTypeToInstrumentProcessesInstruments < ActiveRecord::Migration
  def self.up
    add_column :instrument_processes_instruments, :bed_verification_type, :string
  end

  def self.down
    remove_column :instrument_processes_instruments, :bed_verification_type
  end
end

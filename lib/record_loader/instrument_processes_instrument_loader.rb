# frozen_string_literal: true

# This file was automatically generated via `rails g record_loader`
require_relative "application_record_loader"

# RecordLoader handles automatic population and updating of database records
# across different environments
# @see https://rubydoc.info/github/sanger/record_loader/
module RecordLoader
  # Creates the specified plate types if they are not present
  class InstrumentProcessesInstrumentLoader < ApplicationRecordLoader
    config_folder "instrument_processes_instruments"

    # Creates the specified instrument process and instrument link if it is not present.
    #
    # @param _name [String] The name of the section in the YAML file.
    # @param options [Hash] The options to create the instrument process and instrument link with.
    #
    # @return [InstrumentProcessesInstrument] The created or updated instrument process and instrument link.
    def create_or_update!(_name, options)
      instrument, instrument_process = options.fetch_values("instrument", "instrument_process")
      InstrumentProcessesInstrument.create_with(options.except("instrument", "instrument_process")).find_or_create_by!(
        instrument_id: instruments.fetch(instrument),
        instrument_process_id: instrument_processes.fetch(instrument_process)
      )
    end

    def instruments
      @instruments ||= Instrument.pluck(:name, :id).to_h
    end

    def instrument_processes
      @instrument_processes ||= InstrumentProcess.pluck(:key, :id).to_h
    end
  end
end

# frozen_string_literal: true

# This file was automatically generated via `rails g record_loader`
namespace :record_loader do
  desc 'Automatically generate InstrumentProcessesInstrument through InstrumentProcessesInstrumentLoader'
  task instrument_processes_instrument: [
    :environment,
    'record_loader:instrument',
    'record_loader:instrument_process'] do
      require './lib/record_loader/instrument_processes_instrument_loader'
    RecordLoader::InstrumentProcessesInstrumentLoader.new.create!
  end
end

# Automatically run this record loader as part of record_loader:all
# Remove this line if the task should only run when invoked explicitly
task 'record_loader:all' => 'record_loader:instrument_processes_instrument'

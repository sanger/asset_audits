# frozen_string_literal: true

# This file was automatically generated via `rails g record_loader`
namespace :record_loader do
  desc "Automatically generate InstrumentProcess through InstrumentProcessLoader"
  task instrument_process: :environment do
    require "./lib/record_loader/instrument_process_loader"
    RecordLoader::InstrumentProcessLoader.new.create!
  end
end

# Automatically run this record loader as part of record_loader:all
# Remove this line if the task should only run when invoked explicitly
task "record_loader:all" => "record_loader:instrument_process" # rubocop:todo Rake/Desc

# frozen_string_literal: true

namespace :record_loader do
  desc "Automatically generate Bed through BedLoader"

  # This task is executed after the instrument task.
  task bed: [:environment, "record_loader:instrument"] do
    require "./lib/record_loader/bed_loader"
    RecordLoader::BedLoader.new.create!
  end
end

# Automatically run this record loader as part of record_loader:all
# Remove this line if the task should only run when invoked explicitly
task "record_loader:all" => "record_loader:bed" # rubocop:todo Rake/Desc

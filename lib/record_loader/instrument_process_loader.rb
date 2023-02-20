# frozen_string_literal: true

# This file was automatically generated via `rails g record_loader`

# RecordLoader handles automatic population and updating of database records
# across different environments
# @see https://rubydoc.info/github/sanger/record_loader/
module RecordLoader
  # Creates the specified plate types if they are not present
  class InstrumentProcessLoader < ApplicationRecordLoader
    config_folder "instrument_processes"

    def create_or_update!(key, options)
      InstrumentProcess.create_with(options).find_or_create_by!(key:)
    end
  end
end

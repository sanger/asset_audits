# frozen_string_literal: true

require_relative "application_record_loader"

module RecordLoader
  class BedLoader < ApplicationRecordLoader
    config_folder "beds"

    # Creates the specified bed if it is not present.
    #
    # @param _name [String] The name of the section in the YAML file.
    # @param options [Hash] The options to create the bed with.
    # @return [Bed] The created or updated bed.
    def create_or_update!(_name, options)
      instrument_name = options.fetch("instrument")
      # The loader rake task defines the instrument as dependency.
      instrument = Instrument.find_by!(name: instrument_name)

      Bed.create_with(options.except("instrument")).find_or_create_by!(
        instrument_id: instrument.id,
        bed_number: options.fetch("bed_number")
      )
    end
  end
end

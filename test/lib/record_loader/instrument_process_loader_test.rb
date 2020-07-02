# frozen_string_literal: true

require 'test_helper'
require './lib/record_loader/instrument_process_loader'

class RecordLoader::InstrumentProcessLoaderTest < ActiveSupport::TestCase
  attr_reader :record_loader, :selected_files

  setup do
    test_directory = Rails.root.join('test/data/record_loader/instrument_processes')
    @record_loader = RecordLoader::InstrumentProcessLoader.new(directory: test_directory, files: selected_files)
    @selected_files = 'two_entry_example'
  end

  context 'with two_entry_example selected' do

    should 'create two records' do
      expect { record_loader.create! }.to change { InstrumentProcess.count }.by(2)
    end

    # It is important that multiple runs of a RecordLoader do not create additional
    # copies of existing records.
    should 'be idempotent' do
      record_loader.create!
      expect { record_loader.create! }.not_to change { InstrumentProcess.count }
    end

    should 'set attributes on the created records' do
      record_loader.create!
      expect(InstrumentProcess.first).to have_attributes(
        name: 'Instrument Process 1',
        key: 'instrument_process_1',
        request_instrument: true,
        visual_check_required: false
      )
    end
  end
end

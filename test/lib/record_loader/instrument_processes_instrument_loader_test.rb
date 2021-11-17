# frozen_string_literal: true

require 'test_helper'
require './lib/record_loader/instrument_processes_instrument_loader'

class RecordLoader::InstrumentProcessesInstrumentLoaderTest < ActiveSupport::TestCase
  attr_reader :record_loader, :selected_files

  setup do
    test_directory = Rails.root.join('test/data/record_loader/instrument_process_instruments')
    @instrument = FactoryBot.create :instrument, name: 'test_instrument'
    @instrument_process = FactoryBot.create :instrument_process, key: 'test_process'
    FactoryBot.create :instrument_process, key: 'test_process_2'

    @record_loader =
      RecordLoader::InstrumentProcessesInstrumentLoader.new(directory: test_directory, files: selected_files)
    @selected_files = 'two_entry_example'
  end

  context 'with two_entry_example selected' do
    should 'create two records' do
      expect { record_loader.create! }.to change(InstrumentProcessesInstrument, :count).by(2)
    end

    # It is important that multiple runs of a RecordLoader do not create additional
    # copies of existing records.
    should 'be idempotent' do
      record_loader.create!
      expect { record_loader.create! }.not_to change(InstrumentProcessesInstrument, :count)
    end

    should 'set attributes on the created records' do
      record_loader.create!
      expect(InstrumentProcessesInstrument.first).to have_attributes(
        instrument_id: @instrument.id,
        instrument_process_id: @instrument_process.id,
        witness: true,
        bed_verification_type: 'Verification::Base'
      )
    end
  end
end

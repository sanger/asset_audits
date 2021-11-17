# frozen_string_literal: true

require 'test_helper'
require './lib/record_loader/instrument_loader'

class RecordLoader::InstrumentLoaderTest < ActiveSupport::TestCase
  attr_reader :record_loader, :selected_files

  setup do
    test_directory = Rails.root.join('test/data/record_loader/instruments')
    @record_loader = RecordLoader::InstrumentLoader.new(directory: test_directory, files: selected_files)
    @selected_files = 'two_entry_example'
  end

  context 'with two_entry_example selected' do
    should 'create two records' do
      expect { record_loader.create! }.to change(Instrument, :count).by(2)
    end

    # It is important that multiple runs of a RecordLoader do not create additional
    # copies of existing records.
    should 'be idempotent' do
      record_loader.create!
      expect { record_loader.create! }.not_to change(Instrument, :count)
    end

    should 'set attributes on the created records' do
      record_loader.create!
      expect(Instrument.first).to have_attributes(name: 'Instrument 1', barcode: '1')
    end
  end
end

# frozen_string_literal: true
require 'test_helper'
require 'support/test_sequencescape_api'
require 'support/test_search_result'

class ProcessPlateTest < ActiveSupport::TestCase
  context 'Generating remote asset audits' do
    setup do
      ipi = FactoryBot :instrument_processes_instrument
      @instrument = ipi.instrument
      @instrument_process = ipi.instrument_process
    end

    context 'where all parameters are valid' do
      setup do
        User.stubs(:login_from_user_code).with('123').returns('abc')
        User.stubs(:login_from_user_code).with('456').returns('def')
        @api = TestSequencescapeApi.new(['DN456S'] => [TestSearchResult.new('DN456S', uuid: 'plate-uuid')])

        process_plate = ProcessPlate.new(
          api: @api,
          user_barcode: '123',
          instrument_barcode: @instrument.barcode.to_s,
          source_plates: 'DN456S',
          visual_check: false,
          instrument_process_id: @instrument.instrument_processes.first.id.to_s,
          witness_barcode: '456'
        )
        process_plate.save
        process_plate.create_audits_without_delay
      end

      should 'generate remote asset audits' do
        assert_equal @api.asset_audit.created.length, 1
        assert_equal(@api.asset_audit.created.first, key: @instrument_process.key,
                                                     message: "Process '#{@instrument_process.name}' performed on instrument #{@instrument.name}",
                                                     created_by: 'abc',
                                                     asset: 'plate-uuid',
                                                     witnessed_by: 'def')
      end
    end
  end
end

# frozen_string_literal: true
require 'test_helper'
class WitnessTest < ActiveSupport::TestCase
  context 'Adding Audits for assets which require a witness' do
    setup do
      ipi = Factory :instrument_processes_instrument, witness: true
      @instrument = ipi.instrument
      @instrument_process = ipi.instrument_process

      @input_params = {
        user_barcode: '123',
        instrument_barcode: @instrument.barcode.to_s,
        instrument_process: @instrument.instrument_processes.first.id.to_s,
        source_plates: 'source1',
        witness_barcode: '987'
      }
      @old_delayed_job_count = Delayed::Job.count
      @bed_layout_verification = Verification::Base.new(instrument_barcode: @input_params[:instrument_barcode], scanned_values: @input_params[:robot])
      User.expects(:login_from_user_code).with(@input_params[:user_barcode]).returns('abc')
    end

    context 'where all parameters are valid' do
      setup do
        User.expects(:login_from_user_code).with(@input_params[:witness_barcode]).returns('xyz')

        @bed_layout_verification.validate_and_create_audits?(@input_params)
        @new_delayed_job_count = Delayed::Job.count
      end

      should 'not have any errors' do
        assert_equal [], @bed_layout_verification.errors.values
      end

      should 'create audits' do
        assert_equal @old_delayed_job_count + 1, @new_delayed_job_count
      end
    end

    [['123', 'abc'], ['', nil], ['abc', nil]].each do |witness_barcode, witness_login|
      context "where invalid witness barcodes are scanned with #{witness_barcode}" do
        setup do
          @input_params[:witness_barcode] = witness_barcode
          User.expects(:login_from_user_code).with(@input_params[:witness_barcode]).returns(witness_login)

          @bed_layout_verification.validate_and_create_audits?(@input_params)
          @new_delayed_job_count = Delayed::Job.count
        end

        should 'return an error' do
          assert @bed_layout_verification.errors.values.flatten.include?('Invalid witness barcode')
        end

        should 'not create any audits' do
          assert_equal @new_delayed_job_count, @old_delayed_job_count
        end
      end
    end
  end
end

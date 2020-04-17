# frozen_string_literal: true
require 'test_helper'
require 'support/test_sequencescape_api'
require 'support/test_search_result'

class DilutionPlateVerificationTest < ActiveSupport::TestCase
  context 'Verifying the creation of dilution plates' do
    setup do
      ipi = FactoryBot :instrument_processes_instrument
      @instrument = ipi.instrument
      @instrument_process = ipi.instrument_process
      Bed.all.map { |bed| bed.update_attributes!(instrument_id: @instrument.id) }
    end

    context 'where valid barcodes are scanned' do
      setup do
        @input_params = {
          user_barcode: '123',
          instrument_barcode: @instrument.barcode.to_s,
          instrument_process: @instrument.instrument_processes.first.id.to_s,
          robot: {
            p2: { bed: '2', plate: 'DN123T' },
            p5: { bed: '',  plate: '' },
            p8: { bed: '',  plate: '' },
            p11: { bed: '', plate: '' },
            p3: { bed: '3', plate: 'DN456S' },
            p6: { bed: '',  plate: '' },
            p9: { bed: '',  plate: '' },
            p12: { bed: '', plate: '' }
          }
        }

        api = TestSequencescapeApi.new({ 'DN456S' => [TestSearchResult.new('DN123T')] })

        @old_delayed_job_count = Delayed::Job.count
        @bed_layout_verification = Verification::DilutionPlate::Nx.new(instrument_barcode: @input_params[:instrument_barcode], scanned_values: @input_params[:robot], api: api)
        User.expects(:login_from_user_code).with(@input_params[:user_barcode]).returns('abc')

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

    [
      ['3', '123', '2', '456', 'Invalid layout'],
      ['2', '456', '3', '123', 'Invalid source plate layout: 456 is not a parent of 123. 123 has no known parents.'],
      ['3', '456', '2', '123', 'Invalid layout'],
      ['', '', '', '', 'No plates scanned'],
      ['2', '', '', '', 'No plates scanned'],
      ['2', '123', '', '', 'Invalid destination plate layout'],
      ['2', '123', '3', '', 'Invalid layout'],
      ['2', '123', '', '456', 'Invalid layout'],
      ['', '123', '3', '456', 'Invalid layout'],
      ['', '', '3', '456', 'Invalid source plate layout'],
      ['', '', '', '456', 'Invalid layout'],
      ['2', '', '3', '', 'No plates scanned'],
      ['', '123', '', '456', 'Invalid layout']
    ].each do |source_bed, source_plate, destination_bed, destination_plate, error_message|
      context "where invalid bed barcodes are scanned for #{source_bed}, #{source_plate}, #{destination_bed}, #{destination_plate}, #{error_message}" do
        setup do
          @input_params = {
            user_barcode: '123',
            instrument_barcode: @instrument.barcode.to_s,
            instrument_process: @instrument.instrument_processes.first.id.to_s,
            robot: {
              p2: { bed: source_bed, plate: source_plate },
              p5: { bed: '',   plate: '' },
              p8: { bed: '',   plate: '' },
              p11: { bed: '', plate: '' },
              p3: { bed: destination_bed, plate: destination_plate },
              p6: { bed: '',   plate: '' },
              p9: { bed: '',   plate: '' },
              p12: { bed: '', plate: '' }
            }
          }

          api = TestSequencescapeApi.new({ '456' => [TestSearchResult.new('123')], '123' => [], '' => [] })

          @old_delayed_job_count = Delayed::Job.count
          @bed_layout_verification = Verification::DilutionPlate::Nx.new(instrument_barcode: @input_params[:instrument_barcode], scanned_values: @input_params[:robot], api: api)
          User.expects(:login_from_user_code).with(@input_params[:user_barcode]).returns('abc')

          @bed_layout_verification.validate_and_create_audits?(@input_params)
          @new_delayed_job_count = Delayed::Job.count
        end

        should 'return an error' do
          assert_includes @bed_layout_verification.errors.values.flatten, error_message
        end

        should 'not create any audits' do
          assert_equal @old_delayed_job_count, @new_delayed_job_count
        end
      end
    end
  end
end

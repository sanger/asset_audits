# frozen_string_literal: true
require 'test_helper'
require 'support/test_sequencescape_api'
require 'support/test_search_result'

class QuadStampVerificationTest < ActiveSupport::TestCase
  context 'Verifying the stamping of 4 sources into 1 destination' do
    setup do
      ipi = FactoryBot.create(:instrument_processes_instrument)
      @instrument = ipi.instrument
      @instrument_process = ipi.instrument_process
    end

    context 'nx robot' do
      context 'with one quadrant filled' do
        setup do
          child_plate = FactoryBot.create(:v2_plate_with_parents_and_quadrant_metadata,
                                          barcode: 'DN456S',
                                          metadata: {
                                            'Quadrant 1' => 'DN123T',
                                            'Quadrant 2' => 'Empty',
                                            'Quadrant 3' => 'Empty',
                                            'Quadrant 4' => 'Empty'
                                          },
                                          size: 384)

          Sequencescape::Api::V2::Plate.stubs(:where).with(barcode: 'DN456S').returns([child_plate])

          @input_params = {
            user_barcode: '123',
            instrument_barcode: @instrument.barcode.to_s,
            instrument_process: @instrument.instrument_processes.first.id.to_s,
            robot: {
              p2: { bed: '2', plate: 'DN123T' },
              p5: { bed: '',  plate: '' },
              p8: { bed: '',  plate: '' },
              p11: { bed: '', plate: '' },
              p3: { bed: '3', plate: 'DN456S' }
            }
          }

          api = TestSequencescapeApi.new({ 'DN456S' => [TestSearchResult.new('DN123T')] })

          @old_delayed_job_count = Delayed::Job.count
          @bed_layout_verification = Verification::QuadStampPlate::Nx.new(instrument_barcode: @input_params[:instrument_barcode],
                                                                          scanned_values: @input_params[:robot],
                                                                          api: api)
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

        should 'create a process plate' do
          expect(ProcessPlate.last).to have_attributes(
            user_barcode: '123',
            instrument_barcode: @instrument.barcode.to_s,
            source_plates: 'DN123T DN456S',
            instrument_process_id: @instrument.instrument_processes.first.id,
            visual_check: false,
            metadata: {
              'scanned' => {
                'p2' => { 'bed' => '2', 'plate' => 'DN123T' },
                'p3' => { 'bed' => '3', 'plate' => 'DN456S' }
              }
            }
          )
        end
      end

      context 'with all quadrants filled' do
        setup do
          child_plate = FactoryBot.create(:v2_plate_with_parents_and_quadrant_metadata,
                                          barcode: 'DN456S',
                                          metadata: {
                                            'Quadrant 1' => 'DN123T',
                                            'Quadrant 2' => 'DN123U',
                                            'Quadrant 3' => 'DN123V',
                                            'Quadrant 4' => 'DN123W'
                                          },
                                          size: 384)

          Sequencescape::Api::V2::Plate.stubs(:where).with(barcode: 'DN456S').returns([child_plate])

          @input_params = {
            user_barcode: '123',
            instrument_barcode: @instrument.barcode.to_s,
            instrument_process: @instrument.instrument_processes.first.id.to_s,
            robot: {
              p2: { bed: '2', plate: 'DN123T' },
              p5: { bed: '5',  plate: 'DN123U' },
              p8: { bed: '8',  plate: 'DN123V' },
              p11: { bed: '11', plate: 'DN123W' },
              p3: { bed: '3', plate: 'DN456S' }
            }
          }

          api = TestSequencescapeApi.new({ 'DN456S' => [TestSearchResult.new('DN123T')] })

          @old_delayed_job_count = Delayed::Job.count
          @bed_layout_verification = Verification::QuadStampPlate::Nx.new(instrument_barcode: @input_params[:instrument_barcode],
                                                                          scanned_values: @input_params[:robot],
                                                                          api: api)
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

        should 'create a process plate' do
          expect(ProcessPlate.last).to have_attributes(
            user_barcode: '123',
            instrument_barcode: @instrument.barcode.to_s,
            source_plates: 'DN123T DN456S DN123U DN456S DN123V DN456S DN123W DN456S',
            instrument_process_id: @instrument.instrument_processes.first.id,
            visual_check: false,
            metadata: {
              'scanned' => {
                'p2' => { 'bed' => '2', 'plate' => 'DN123T' },
                'p5' => { 'bed' => '5',  'plate' => 'DN123U' },
                'p8' => { 'bed' => '8',  'plate' => 'DN123V' },
                'p11' => { 'bed' => '11', 'plate' => 'DN123W' },
                'p3' => { 'bed' => '3', 'plate' => 'DN456S' }
              }
            }
          )
        end
      end

      context 'where it is invalid' do
        setup do
          child_plate = FactoryBot.create(:v2_plate_with_parents_and_quadrant_metadata,
                                          barcode: 'DN456S',
                                          metadata: {
                                            'Quadrant 1' => 'Empty',
                                            'Quadrant 2' => 'DN123T',
                                            'Quadrant 3' => 'Empty',
                                            'Quadrant 4' => 'Empty'
                                          },
                                          size: 384)
          # need a factory that creates a v2 plate with parents & custom metadata referencing those parents
          # 2 robots

          Sequencescape::Api::V2::Plate.stubs(:where).with(barcode: 'DN456S').returns([child_plate])

          @input_params = {
            user_barcode: '123',
            instrument_barcode: @instrument.barcode.to_s,
            instrument_process: @instrument.instrument_processes.first.id.to_s,
            robot: {
              p2: { bed: '2', plate: 'DN123T' },
              p5: { bed: '',  plate: '' },
              p8: { bed: '',  plate: '' },
              p11: { bed: '', plate: '' },
              p3: { bed: '3', plate: 'DN456S' }
            }
          }

          api = TestSequencescapeApi.new({ 'DN456S' => [TestSearchResult.new('DN123T')] })

          @old_delayed_job_count = Delayed::Job.count
          @bed_layout_verification = Verification::QuadStampPlate::Nx.new(instrument_barcode: @input_params[:instrument_barcode],
                                                                          scanned_values: @input_params[:robot],
                                                                          api: api)
          User.expects(:login_from_user_code).at_least(0).with(@input_params[:user_barcode]).returns('abc')

          @bed_layout_verification.validate_and_create_audits?(@input_params)
          @new_delayed_job_count = Delayed::Job.count
        end

        should 'return an error' do
          error_message = 'The barcode in bed P2 doesn\'t match the plate in Quadrant 1 on the destination plate.'
          assert_includes @bed_layout_verification.errors.values.flatten, error_message
        end
      end
    end

    context 'bravo robot' do
      context 'with one quadrant filled' do
        setup do
          child_plate = FactoryBot.create(:v2_plate_with_parents_and_quadrant_metadata,
                                          barcode: 'DN456S',
                                          metadata: {
                                            'Quadrant 1' => 'DN123T',
                                            'Quadrant 2' => 'Empty',
                                            'Quadrant 3' => 'Empty',
                                            'Quadrant 4' => 'Empty'
                                          },
                                          size: 384)

          Sequencescape::Api::V2::Plate.stubs(:where).with(barcode: 'DN456S').returns([child_plate])

          @input_params = {
            user_barcode: '123',
            instrument_barcode: @instrument.barcode.to_s,
            instrument_process: @instrument.instrument_processes.first.id.to_s,
            robot: {
              p1: { bed: '1', plate: 'DN123T' },
              p4: { bed: '',  plate: '' },
              p3: { bed: '',  plate: '' },
              p6: { bed: '', plate: '' },
              p5: { bed: '5', plate: 'DN456S' }
            }
          }

          api = TestSequencescapeApi.new({ 'DN456S' => [TestSearchResult.new('DN123T')] })

          @old_delayed_job_count = Delayed::Job.count
          @bed_layout_verification = Verification::QuadStampPlate::Bravo.new(instrument_barcode: @input_params[:instrument_barcode],
                                                                             scanned_values: @input_params[:robot],
                                                                             api: api)
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

      context 'with all quadrants filled' do
        setup do
          child_plate = FactoryBot.create(:v2_plate_with_parents_and_quadrant_metadata,
                                          barcode: 'DN456S',
                                          metadata: {
                                            'Quadrant 1' => 'DN123T',
                                            'Quadrant 2' => 'DN123U',
                                            'Quadrant 3' => 'DN123V',
                                            'Quadrant 4' => 'DN123W'
                                          },
                                          size: 384)

          Sequencescape::Api::V2::Plate.stubs(:where).with(barcode: 'DN456S').returns([child_plate])

          @input_params = {
            user_barcode: '123',
            instrument_barcode: @instrument.barcode.to_s,
            instrument_process: @instrument.instrument_processes.first.id.to_s,
            robot: {
              p1: { bed: '1', plate: 'DN123T' },
              p4: { bed: '4',  plate: 'DN123U' },
              p3: { bed: '3',  plate: 'DN123V' },
              p6: { bed: '6', plate: 'DN123W' },
              p5: { bed: '5', plate: 'DN456S' }
            }
          }

          api = TestSequencescapeApi.new({ 'DN456S' => [TestSearchResult.new('DN123T')] })

          @old_delayed_job_count = Delayed::Job.count
          @bed_layout_verification = Verification::QuadStampPlate::Bravo.new(instrument_barcode: @input_params[:instrument_barcode],
                                                                             scanned_values: @input_params[:robot],
                                                                             api: api)
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

      context 'where it is invalid' do
        setup do
          child_plate = FactoryBot.create(:v2_plate_with_parents_and_quadrant_metadata,
                                          barcode: 'DN456S',
                                          metadata: {
                                            'Quadrant 1' => 'Empty',
                                            'Quadrant 2' => 'DN123T',
                                            'Quadrant 3' => 'Empty',
                                            'Quadrant 4' => 'Empty'
                                          },
                                          size: 384)
          # need a factory that creates a v2 plate with parents & custom metadata referencing those parents
          # 2 robots

          Sequencescape::Api::V2::Plate.stubs(:where).with(barcode: 'DN456S').returns([child_plate])

          @input_params = {
            user_barcode: '123',
            instrument_barcode: @instrument.barcode.to_s,
            instrument_process: @instrument.instrument_processes.first.id.to_s,
            robot: {
              p1: { bed: '1', plate: 'DN123T' },
              p4: { bed: '',  plate: '' },
              p3: { bed: '',  plate: '' },
              p6: { bed: '', plate: '' },
              p5: { bed: '5', plate: 'DN456S' }
            }
          }

          api = TestSequencescapeApi.new({ 'DN456S' => [TestSearchResult.new('DN123T')] })

          @old_delayed_job_count = Delayed::Job.count
          @bed_layout_verification = Verification::QuadStampPlate::Bravo.new(instrument_barcode: @input_params[:instrument_barcode],
                                                                             scanned_values: @input_params[:robot],
                                                                             api: api)
          User.expects(:login_from_user_code).at_least(0).with(@input_params[:user_barcode]).returns('abc')

          @bed_layout_verification.validate_and_create_audits?(@input_params)
          @new_delayed_job_count = Delayed::Job.count
        end

        should 'return an error' do
          error_message = 'The barcode in bed P1 doesn\'t match the plate in Quadrant 1 on the destination plate.'
          assert_includes @bed_layout_verification.errors.values.flatten, error_message
        end
      end
    end
  end
end

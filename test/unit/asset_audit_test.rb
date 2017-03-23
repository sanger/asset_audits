require 'test_helper'
class AssetAuditTest < ActiveSupport::TestCase
  context "Adding Audits for Assets" do
    setup do
      ipi = Factory :instrument_processes_instrument
      @instrument = ipi.instrument
      @instrument_process = ipi.instrument_process

      @input_params = {
        user_barcode: "123",
        instrument_barcode: @instrument.barcode.to_s,
        instrument_process: @instrument.instrument_processes.first.id.to_s,
        source_plates: "source1"
      }
      @old_delayed_job_count = Delayed::Job.count
    end

    context "where the user barcode is invalid" do
      setup do
        UserBarcode::UserBarcode.stubs(:find_username_from_barcode).returns(nil)
        @bed_layout_verification = Verification::Base.new(instrument_barcode: @input_params[:instrument_barcode], scanned_values: @input_params[:robot])
        @bed_layout_verification.validate_and_create_audits?(@input_params)
        @new_delayed_job_count = Delayed::Job.count
      end

      should "return an error" do
        assert @bed_layout_verification.errors.values.flatten.include?("Invalid user")
      end

      should "not create any audits" do
        assert_equal @new_delayed_job_count, @old_delayed_job_count
      end
    end

    context "where all parameters are valid" do
      setup do
        UserBarcode::UserBarcode.stubs(:find_username_from_barcode).returns("abc")
        @bed_layout_verification = Verification::Base.new(instrument_barcode: @input_params[:instrument_barcode], scanned_values: @input_params[:robot])
        @bed_layout_verification.validate_and_create_audits?(@input_params)
        @new_delayed_job_count = Delayed::Job.count
      end

      should "not have any errors" do
        assert_equal [], @bed_layout_verification.errors.values
      end

      should "create audits" do
        assert_equal @old_delayed_job_count + 1, @new_delayed_job_count
      end
    end
  end
end

# frozen_string_literal: true

require "test_helper"

# This test case is for testing the scanning of labware into the LabWhere
# destroyed location as part of the Asset Audits Destroying labware process,
# which is handled by an instance of Verification::OutdatedLabware::Base.
class LabwareDestructionTest < ActiveSupport::TestCase
  setup do
    # Instances to represent the Destroying instrument and the Destroying
    # labware process.
    ipi = FactoryBot.create(:instrument_processes_instrument)
    @instrument = ipi.instrument # Destroying instrument
    @instrument_process = ipi.instrument_process # Destroying labware process

    # Labware barcodes that can be scanned for auditing and destruction,
    # and the corresponding instances.
    lifespan = 30 # days
    @purpose = FactoryBot.create(:v2_purpose, lifespan:)

    @labware1_barcode = "labware-1-barcode"
    @labware2_barcode = "labware-2-barcode"

    created_at = (lifespan + 2).days.ago # 2 days back to make them outdated
    @labware1 = FactoryBot.create(:v2_plate, barcode: @labware1_barcode, purpose: @purpose, created_at:)
    @labware2 = FactoryBot.create(:v2_plate, barcode: @labware2_barcode, purpose: @purpose, created_at:)

    # User login and the code scanned by the user.
    @user_login = "user-1"
    @user_barcode = "user-1-barcode"

    # URI for the LabWhere API to scan the labware into the destroyed location.
    @scans_uri = URI.join(Settings.labwhere_api, "scans")
  end

  context "with LabWhere service" do
    setup do
      plates = [@labware1, @labware2]
      barcodes = [@labware1_barcode, @labware2_barcode]

      # Parameters passed to the controller by form submission.
      @params = {
        user_barcode: @user_barcode,
        instrument_barcode: @instrument.barcode.to_s,
        instrument_process: @instrument.instrument_processes.first.id.to_s,
        robot: "#{@labware1_barcode}\n#{@labware2_barcode}"
      }
      # Controller creates an instance of Verification::OutdatedLabware::Base
      # for the Destroying instrument and Destroying labware process.
      @verification =
        Verification::OutdatedLabware::Base.new(
          instrument_barcode: @params[:instrument_barcode],
          instrument_process: @params[:instrument_process],
          scanned_values: @params[:robot]
        )

      # Stub API calls to Sequencescape
      User.stubs(:login_from_user_code).with(@params[:user_barcode]).returns(@user_login)
      Sequencescape::Api::V2::Labware.stubs(:where).with(barcode: barcodes).returns(plates)

      # Count of ProcessPlate and Delayed::Job records before the action.
      @old_process_plate_count = ProcessPlate.count
      @old_delayed_job_count = Delayed::Job.count
    end

    context "when validation succeeds" do
      setup do
        # Stub API call to LabWhere, to scan into the destroyed location.
        # The response is a success. The response body and headers are ignored.
        stub_request(:post, @scans_uri).to_return(status: 200)

        # Controller calls the validate_and_create_audits? method.
        @result = @verification.validate_and_create_audits?(@params)
      end

      should "send a POST request to the LabWhere API to scan the labware into the destroyed location" do
        # NB. We will not check this in other tests again.
        # NB. Using double quotes is important for joining the labware barcodes.
        body = {
          scan: {
            user_code: @params[:user_barcode],
            labware_barcodes: [@labware1_barcode, @labware2_barcode].join("\n"),
            location_barcode: @verification.destroyed_location_barcode
          }
        }.to_json

        # Correct request parameters should be sent to LabWhere.
        # Ignore headers in the assertion.
        assert_requested(:post, @scans_uri, times: 1, body:)
      end

      should "return success from the validate_and_create_audits? method" do
        assert @result
      end

      should "not have any errors" do
        assert_empty @verification.errors
      end

      should "create the process plates record" do
        new_process_plate_count = ProcessPlate.count

        assert_equal @old_process_plate_count + 1, new_process_plate_count
      end

      should "create the delayed job for audits" do
        new_delayed_job_count = Delayed::Job.count

        assert_equal @old_delayed_job_count + 1, new_delayed_job_count
      end
    end

    context "when there is a connection error" do
      setup do
        # HTTP POST request to LabWhere will raise a connection error.
        Net::HTTP.stubs(:post).with(@scans_uri, anything, anything).raises(Errno::ECONNREFUSED)

        # Controller calls the validate_and_create_audits? method.
        @result = @verification.validate_and_create_audits?(@params)
      end

      should "connection should raise an error" do
        # NB. This error is caught and handled in the send_scan_request method.
        expect { Net::HTTP.post(@scans_uri, anything, anything) }.to raise_error(Errno::ECONNREFUSED)
      end

      should "return failure from the validate_and_create_audits? method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        assert_includes @verification.errors[:LabWhere], "LabWhere service is down"
      end

      should "not create the process plates record" do
        new_process_plate_count = ProcessPlate.count

        assert_equal @old_process_plate_count, new_process_plate_count
      end

      should "not create the delayed job for audits" do
        new_delayed_job_count = Delayed::Job.count

        assert_equal @old_delayed_job_count, new_delayed_job_count
      end
    end

    context "when the service cannot be found" do
      # This is similar to the connection error case.
      # We can reach the web server instead, but the service is not found.

      setup do
        # Stub API call to LabWhere, to scan into the destroyed location.
        # The response is a failure. The response body and headers are ignored.
        stub_request(:post, @scans_uri).to_return(status: 404)

        # Controller calls the validate_and_create_audits? method.
        @result = @verification.validate_and_create_audits?(@params)
      end

      should "return failure from the validate_and_create_audits? method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        assert_includes @verification.errors[:LabWhere], "LabWhere service is down"
      end

      should "not create the process plates record" do
        new_process_plate_count = ProcessPlate.count

        assert_equal @old_process_plate_count, new_process_plate_count
      end

      should "not create the delayed job for audits" do
        new_delayed_job_count = Delayed::Job.count

        assert_equal @old_delayed_job_count, new_delayed_job_count
      end
    end

    context "when the validation fails" do
      # Any validation errors on the LabWhere service side will be available in
      # the HTTPUnprocessableEntity (422) response body. We are testing that
      # they will be treated as failure and they are added to the errors as
      # feedback to the user.
      setup do
        # Stub API call to LabWhere, to scan into the destroyed location.
        # The response is a failure. The response body is parsed.
        @errors_response = {
          errors: [
            "User does not exist",
            "User is not authorised",
            "Location does not exist",
            "Any existing error that may be returned",
            "Any future error that may be added"
          ]
        }
        stub_request(:post, @scans_uri).to_return(status: 422, body: @errors_response.to_json)

        # Controller calls the validate_and_create_audits? method.
        @result = @verification.validate_and_create_audits?(@params)
      end

      should "return failure from the validate_and_create_audits? method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        # NB. The message contains all errors from the response.
        assert_includes @verification.errors[:LabWhere], @errors_response[:errors].join(", ")
      end

      should "not create the process plates record" do
        new_process_plate_count = ProcessPlate.count

        assert_equal @old_process_plate_count, new_process_plate_count
      end

      should "not create the delayed job for audits" do
        new_delayed_job_count = Delayed::Job.count

        assert_equal @old_delayed_job_count, new_delayed_job_count
      end
    end

    context "when an unexpected error occurs" do
      # This is a catch-all case for any other error that may occur.
      # We are supposed to add a generic error message to the errors object
      # to inform the user that something went wrong, and inspect the logs.

      setup do
        # Stub API call to LabWhere, to scan into the destroyed location.
        # The response is internal server error (500).
        stub_request(:post, @scans_uri).to_return(status: 500)

        # Controller calls the validate_and_create_audits? method.
        @result = @verification.validate_and_create_audits?(@params)
      end

      should "return failure from the validate_and_create_audits? method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        # NB. The message is a generic error message.
        message = "An error occurred while scanning the labware"

        assert_includes @verification.errors[:LabWhere], message
      end

      should "not create the process plates record" do
        new_process_plate_count = ProcessPlate.count

        assert_equal @old_process_plate_count, new_process_plate_count
      end

      should "not create the delayed job for audits" do
        new_delayed_job_count = Delayed::Job.count

        assert_equal @old_delayed_job_count, new_delayed_job_count
      end
    end

    context "when local validation fails" do
      # Before sending the request to LabWhere, the verification instance will
      # validate the parameters locally for auditing. If the validation fails,
      # it will not send a request to LabWhere.
      setup do
        # Make the first labware not outdated and the second not found.
        @labware1.created_at = Time.zone.now # Not outdated.
        @bad_labware_barcode = "bad-labware-barcode"
        barcodes = [@labware1_barcode, @bad_labware_barcode]
        plates = [@labware1] # Only the first labware is found.

        # Parameters passed to the controller by form submission.
        @params[:robot] = "#{@labware1_barcode}\n#{@bad_labware_barcode}"

        # Controller creates an instance of Verification::OutdatedLabware::Base
        # for the Destroying instrument and Destroying labware process.
        @verification =
          Verification::OutdatedLabware::Base.new(
            instrument_barcode: @params[:instrument_barcode],
            instrument_process: @params[:instrument_process],
            scanned_values: @params[:robot]
          )

        # Stub Labware API call to Sequencescape
        # The bad labware barcode is not found in Sequencescape.
        Sequencescape::Api::V2::Labware.stubs(:where).with(barcode: barcodes).returns(plates)

        # Controller calls the validate_and_create_audits? method.
        @result = @verification.validate_and_create_audits?(@params)
      end

      should "return failure from the validate_and_create_audits? method" do
        assert_not @result
      end

      should "have messages added to the errors" do
        # NB. The messages are from local validation.
        message1 = "The labware #{@labware1_barcode} is less than #{@purpose.lifespan} days old"
        message2 = "The labware #{@bad_labware_barcode} hasn't been found"

        assert_includes @verification.errors[:error], message1
        assert_includes @verification.errors[:error], message2
      end

      should "not create the process plates record" do
        new_process_plate_count = ProcessPlate.count

        assert_equal @old_process_plate_count, new_process_plate_count
      end

      should "not create the delayed job for audits" do
        new_delayed_job_count = Delayed::Job.count

        assert_equal @old_delayed_job_count, new_delayed_job_count
      end

      should "not send a POST request to the LabWhere API to scan the labware into the destroyed location" do
        # NB. Because the local validation failed, the request is not sent.
        assert_not_requested(:post, @scans_uri)
      end
    end
  end
end

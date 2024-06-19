# frozen_string_literal: true

require "test_helper"

# This test case is for testing all labware in given location into the LabWhere
# destroyed location which will be performed as part of the Asset Audits Destroying location process,
# which is handled by an instance of Verification::DestroyLocation::Base.
class LocationDestructionTest < ActiveSupport::TestCase
  setup do
    # Instances to represent the Destroying instrument and the Destroying location.
    ipi = FactoryBot.create(:instrument_processes_instrument)
    @instrument = ipi.instrument # Destroying instrument
    @instrument_process = ipi.instrument_process # Destroying labware process

    # Labware barcodes that can be scanned for auditing and destruction,
    # and the corresponding instances.
    lifespan = 30 # days
    @purpose = FactoryBot.create(:v2_purpose, lifespan:)

    @labware1_barcode = "labware-1-barcode"
    @labware2_barcode = "labware-2-barcode"

    @location_barcode = "location-barcode"

    created_at = (lifespan + 2).days.ago # 2 days back to make them outdated
    @labware1 = FactoryBot.create(:v2_plate, barcode: @labware1_barcode, purpose: @purpose, created_at:)
    @labware2 = FactoryBot.create(:v2_plate, barcode: @labware2_barcode, purpose: @purpose, created_at:)

    # User login and the code scanned by the user.
    @user_login = "user-1"
    @user_barcode = "user-1-barcode"

    # URI for the LabWhere API to scan the labware into the destroyed location.
    @info_uri = URI.join(Settings.labwhere_api, "locations/info")
    @scans_uri = URI.join(Settings.labwhere_api, "scans")

    # Count of ProcessPlate and Delayed::Job records before the action.
    @old_process_plate_count = ProcessPlate.count
    @old_delayed_job_count = Delayed::Job.count
  end

  context "with LabWhere service" do
    setup do
      plates = [@labware1, @labware2]
      barcodes = [@labware1_barcode, @labware2_barcode]
      # Parameters passed to the controller when location is entered
      @destroy_location_params = {
        user_barcode: @user_barcode,
        instrument_barcode: @instrument.barcode.to_s,
        instrument_process: @instrument.instrument_processes.first.id.to_s,
        location: @location_barcode
      }
      # Controller creates an instance of Verification::DestroyLocation::Base
      # for the Destroying instrument and Destroying location process.
      @destroy_location_verification =
        Verification::DestroyLocation::Base.new(scanned_values: @destroy_location_params[:location])

      # Parameters passed to the controller by form submission.
      @destroy_labware_params = {
        user_barcode: @user_barcode,
        instrument_barcode: @instrument.barcode.to_s,
        instrument_process: @instrument.instrument_processes.first.id.to_s,
        robot: "#{@labware1_barcode}\n#{@labware2_barcode}"
      }
      # Verification::OutdatedLabware::Base instance for destroying labware inside the location.
      @destroy_labware_verification =
        Verification::OutdatedLabware::Base.new(
          instrument_barcode: @destroy_labware_params[:instrument_barcode],
          instrument_process: @destroy_labware_params[:instrument_process],
          scanned_values: @destroy_labware_params[:robot]
        )

      # Stub API calls to Sequencescape
      User.stubs(:login_from_user_code).with(@destroy_labware_params[:user_barcode]).returns(@user_login)
      Sequencescape::Api::V2::Labware.stubs(:where).with(barcode: barcodes).returns(plates)

      # Count of ProcessPlate and Delayed::Job records before the action.
      @old_process_plate_count = ProcessPlate.count
      @old_delayed_job_count = Delayed::Job.count
    end

    context "when the location is scanned" do
      setup do
        # Stub the API call to LabWhere to get the location info.
        body = { labwares: [{ barcode: @labware1_barcode }, { barcode: @labware2_barcode }], depth: 2 }.to_json
        stub_request(:get, (@info_uri.to_s + "?barcode=#{@location_barcode}")).to_return(body:, status: 200)

        # Controller calls the pre_validate? method.
        @result = @destroy_location_verification.pre_validate
      end

      should "send a GET request to the LabWhere API to get the info of the location entered" do
        # Correct request parameters should be sent to LabWhere.
        assert_requested(:get, "#{@info_uri}?barcode=#{@location_barcode}", times: 1)
      end

      should "return the barcodes of the labware in the location" do
        assert_equal @result, [@labware1_barcode, @labware2_barcode]
      end

      should "not have any errors" do
        assert_empty @destroy_location_verification.errors
      end
    end

    context "when location validation fails in api call" do
      # Any validation errors on the LabWhere service side will be available in
      # the HTTPUnprocessableEntity (422) response body. We are testing that
      # they will be treated as failure and they are added to the errors as
      # feedback to the user.
      setup do
        # Stub API call to LabWhere, to get info of location given.
        # The response is a failure. The response body is parsed.
        @errors_response = { errors: ["Location does not exist", "Error in the location"] }
        stub_request(:get, (@info_uri.to_s + "?barcode=#{@location_barcode}")).to_return(
          body: @errors_response.to_json,
          status: 422
        )

        # Controller calls the pre_validate? method.
        @result = @destroy_location_verification.pre_validate
      end

      should "return failure from the pre_validate method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        # NB. The message contains all errors from the response.
        assert_includes @destroy_location_verification.errors[:LabWhere], @errors_response[:errors].join(", ")
      end
    end
    context "when location has no child locations" do
      setup do
        body = { labwares: [{ barcode: @labware1_barcode }, { barcode: @labware2_barcode }], depth: 0 }.to_json
        stub_request(:get, (@info_uri.to_s + "?barcode=#{@location_barcode}")).to_return(body:, status: 200)

        # Controller calls the pre_validate? method.
        @result = @destroy_location_verification.pre_validate
      end

      should "return failure from the pre_validate method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        # NB. The message contains all errors from the response.
        assert_includes @destroy_location_verification.errors[:LabWhere], "Location does not have any child locations"
      end
    end
    context "when location has no labware" do
      setup do
        body = { labwares: [], depth: 2 }.to_json
        stub_request(:get, (@info_uri.to_s + "?barcode=#{@location_barcode}")).to_return(body:, status: 200)

        # Controller calls the pre_validate? method.
        @result = @destroy_location_verification.pre_validate
      end

      should "return failure from the pre_validate method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        # NB. The message contains all errors from the response.
        assert_includes @destroy_location_verification.errors[:LabWhere], "Location does not have any labware"
      end
    end

    context "when form is submitted to destroy locaton" do
      setup do
        # Stub API call to LabWhere, to scan into the destroyed location..
        stub_request(:post, @scans_uri).to_return(status: 200)
        @result = @destroy_location_verification.validate_and_create_audits?(@destroy_labware_params)
      end

      should "send a POST request to the LabWhere API to scan the labware into the destroyed location" do
        body = {
          scan: {
            user_code: @user_barcode,
            labware_barcodes: [@labware1_barcode, @labware2_barcode].join("\n"),
            location_barcode: Verification::LabwhereApi::DESTROY_LOCATION_BARCODE
          }
        }.to_json

        assert_requested(:post, @scans_uri, times: 1, body:)
      end

      should "return success from the validate_and_create_audits? method" do
        assert @result
      end

      should "not have any errors" do
        assert_empty @destroy_location_verification.errors
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
    context "when the validation fails" do
      setup do
        @errors_response = { errors: ["Location does not exist", "Error returned"] }

        stub_request(:post, @scans_uri).to_return(status: 422, body: @errors_response.to_json)

        @result = @destroy_location_verification.validate_and_create_audits?(@destroy_labware_params)
      end

      should "return failure from the validate_and_create_audits? method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        assert_includes @destroy_location_verification.errors[:LabWhere], @errors_response[:errors].join(", ")
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
  end
end

# frozen_string_literal: true

require "test_helper"

class LabwhereApiTest < ActiveSupport::TestCase
  setup do
    @dummy =
      Class
        .new do
          include Verification::LabwhereApi
          include ActiveModel::Model
        end
        .new
    @scans_uri = URI.join(Settings.labwhere_api, "scans")
    @location_uri = URI.join(Settings.labwhere_api, "locations/info")
    @user_barcode = "user-1-barcode"
    @barcodes = %w[labware-1-barcode labware-2-barcode]
    @headers = { "Content-Type" => "application/json" }
    @location_barcode = "location-1-barcode"
  end

  context "#scan_into_destroyed_location" do
    context("when the request is successful") do
      setup do
        stub_request(:post, @scans_uri).to_return(status: 200)
        @result = @dummy.scan_into_destroyed_location(@user_barcode, @barcodes)
      end

      should "returns true" do
        assert @result
      end

      should "sends a POST request to the correct URL with the correct body and headers" do
        body = {
          scan: {
            user_code: @user_barcode,
            labware_barcodes: @barcodes.join("\n"),
            location_barcode: Verification::LabwhereApi::DESTROYED_LOCATION_BARCODE
          }
        }.to_json

        # Correct request parameters should be sent to LabWhere.
        # Ignore headers in the assertion.
        assert_requested(:post, @scans_uri, times: 1, body:)
      end
    end
    context "when there is a connection error" do
      setup do
        # HTTP POST request to LabWhere will raise a connection error.
        Net::HTTP.stubs(:post).with(@scans_uri, anything, anything).raises(Errno::ECONNREFUSED)

        @result = @dummy.scan_into_destroyed_location(@user_barcode, @barcodes)
      end

      should "connection should raise an error" do
        expect { Net::HTTP.post(@scans_uri, anything, anything) }.to raise_error(Errno::ECONNREFUSED)
      end

      should "return failure from the validate_and_create_audits? method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        assert_includes @dummy.errors[:LabWhere], "LabWhere service is down"
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
        @errors_response = { errors: ["Location does not exist", "Error in labware barcode 1"] }
        stub_request(:post, @scans_uri).to_return(status: 422, body: @errors_response.to_json)

        # Controller calls the validate_and_create_audits? method.
        @result = @dummy.scan_into_destroyed_location(@user_barcode, @barcodes)
      end

      should "return failure from the validate_and_create_audits? method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        # NB. The message contains all errors from the response.
        assert_includes @dummy.errors[:LabWhere], @errors_response[:errors].join(", ")
      end
    end
  end

  context "#location_info" do
    context "when request is succesful" do
      setup do
        @location_info = { depth: 2, labwares: [{ barcode: "labware-1-barcode" }, { barcode: "labware-2-barcode" }] }
        stub_request(:get, (@location_uri.to_s + "?barcode=#{@location_barcode}")).to_return(
          body: @location_info.to_json,
          status: 200
        )
        @result = @dummy.location_info(@location_barcode)
      end

      should "return the location info" do
        assert_equal @location_info, @result.deep_symbolize_keys
      end
    end
    context "when there is a connection error" do
      setup do
        stub_request(:get, (@location_uri.to_s + "?barcode=#{@location_barcode}")).to_raise(Errno::ECONNREFUSED)
        @result = @dummy.location_info(@location_barcode)
      end

      should "return failure from the location_info method" do
        assert_nil(@result)
      end

      should "have a message added to the errors" do
        assert_includes @dummy.errors[:LabWhere], "LabWhere service is down"
      end
    end
    context "when validation fails on the LabWhere side" do
      # Any validation errors on the LabWhere service side will be available in
      # the HTTPUnprocessableEntity (422) response body. We are testing that
      # they will be treated as failure and they are added to the errors as
      # feedback to the user.
      setup do
        @errors_response = { errors: ["Location does not exist", "Error in the location", "Random error message"] }
        # Stub API call to LabWhere, to get info of location given.
        # The response is a failure. The response body is parsed
        stub_request(:get, (@location_uri.to_s + "?barcode=#{@location_barcode}")).to_return(
          body: @errors_response.to_json,
          status: 422
        )
        @result = @dummy.location_info(@location_barcode)
      end

      should "return failure from the location_info method" do
        assert_not @result
      end

      should "have a message added to the errors" do
        assert_includes @dummy.errors[:LabWhere], @errors_response[:errors].join(", ")
      end
    end
    context "when an unknown error occurs on the LabWhere side" do
      setup do
        # Stub API call to LabWhere, to get info of location given.
        # The response is a failure with an unknown status code.
        stub_request(:get, (@location_uri.to_s + "?barcode=#{@location_barcode}")).to_return(
          body: {}.to_json,
          status: 500
        ) # Use a different status code
        @result = @dummy.location_info(@location_barcode)
      end

      should "return failure from the location_info method" do
        assert_not @result
      end

      should "have a generic error message added to the errors" do
        assert_includes @dummy.errors[:LabWhere], "An error occurred while scanning the labware"
      end
    end
  end
end

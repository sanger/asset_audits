# frozen_string_literal: true

require "test_helper"

class SequencescapeApiV2Test < ActiveSupport::TestCase
  context "Sequencescape::Api::V2::Base" do
    should "has the correct site" do
      assert_equal(Sequencescape::Api::V2::Base.site, Settings.sequencescape_api_v2)
    end

    should "has the correct connection options headers" do
      headers = Sequencescape::Api::V2::Base.connection_options[:headers]

      assert_equal(headers, { "X-Sequencescape-Client-Id" => Settings.sequencescape_authorisation })
    end
  end

  context "Sequencescape::Api::V2::User" do
    should "has the correct site" do
      assert_equal(Sequencescape::Api::V2::User.site, Settings.sequencescape_api_v2)
    end

    should "has the correct connection options headers" do
      headers = Sequencescape::Api::V2::User.connection_options[:headers]

      assert_equal(headers, { "X-Sequencescape-Client-Id" => Settings.sequencescape_authorisation })
    end

    should "includes the API key in the requests" do
      # We can assert that the resource has the correct api key in the headers by the fact it is
      # being successfully stubbed
      stub_request(:get, %r{api/v2/users}).with(
        headers: {
          "X-Sequencescape-Client-Id" => Settings.sequencescape_authorisation
        }
      ).to_return(
        {
          status: 200,
          headers: {
            "Content-Type": "application/vnd.api+json"
          },
          body: JSON.generate({ data: [{ attributes: { login: "12345" } }] })
        }
      )

      user = Sequencescape::Api::V2::User.first
      expect(user.type).to eq("users")
    end
  end
end

# frozen_string_literal: true

require "simplecov"
SimpleCov.start

ENV["RAILS_ENV"] = "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "minitest/autorun"
require "webmock/minitest"
require "mocha/minitest"
require "capybara/rails"
require "capybara/minitest"
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  include RSpec::Matchers

  def generate_success_response(barcode, purpose_name, study_names)
    {
      barcode:,
      code: "201",
      body: {
        "data" => {
          "attributes" => {
            "purpose_name" => purpose_name,
            "study_names" => study_names
          }
        }
      }
    }
  end

  def generate_fail_response(barcode)
    { barcode:, code: "400", body: { errors: ["No samples for this barcode"] } }
  end
end

# Configure Capybara to use Selenium and Chrome for JavaScript tests
Capybara.javascript_driver = :selenium_chrome_headless

# Ensure that the test layout includes the necessary JavaScript files
class ActionDispatch::IntegrationTest
  include Capybara::DSL

  setup { Capybara.current_driver = Capybara.javascript_driver }

  teardown { Capybara.use_default_driver }
end


# config/environments/test.rb
Rails.application.configure do

  # Ensure assets are precompiled and served in the test environment
  config.assets.compile = true
  config.assets.digest = true
  config.assets.debug = false
end

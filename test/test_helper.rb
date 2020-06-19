# frozen_string_literal: true
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'webmock/minitest'
require 'mocha/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def generate_success_response(barcode, purpose_name, study_names)
    {
      barcode: barcode,
      code: '201',
      body: {
        'data' => {
          'attributes'=> {
            'purpose_name' => purpose_name,
            'study_names' => study_names
          }
        }
      }
    }
  end

  def generate_fail_response(barcode)
    {
      barcode: barcode,
      code: '400',
      body: {
        'errors': [
          'No samples for this barcode'
        ]
      }
    }
  end
end

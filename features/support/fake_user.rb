# frozen_string_literal: true

require 'singleton'

class FakeUser
  include Singleton

  def user_barcodes
    @user_barcodes ||= {}
  end

  def clear
    @user_barcodes = {}
  end

  def user_barcode(user, barcode)
    user_barcodes[barcode] = user
  end

  def login_from_user_code(barcode)
    user_barcodes[barcode]
  end

  def self.install_hooks(target, tags)
    target.instance_eval do
      Before(tags) do |_scenario|
        Capybara.current_session.driver.browser if Capybara.current_driver == Capybara.javascript_driver
        stub_request(:get, %r{#{Settings.sequencescape_api_v2}/users\?filter\[user_code\].*}).to_return do |request|
          user_code = request.uri.query_values['filter[user_code]']
          body_hash = {
            data: [
              {
                attributes: {
                  login: FakeUser.instance.login_from_user_code(user_code)
                }
              }
            ]
          }
          FakeUser.response_format(body_hash)
        end
      end

      After(tags) do |_scenario|
        FakeUser.instance.clear
      end
    end
  end

  def self.response_format(body_value)
    {
      status: 200,
      headers: { 'Content-Type': 'application/vnd.api+json' },
      body: JSON.generate(body_value)
    }
  end
end

FakeUser.install_hooks(self, '@user_barcode_service')

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # We are limiting the number of messages to display to avoid the page
  # becoming too long and the ActionDispatch::Cookies::CookieOverflow
  # error being raised (because the error message is set in a flash message).
  MAX_NUMBER_OF_ERROR_MESSAGES = 5

  protect_from_forgery
  include ::Sequencescape::Api::Rails::ApplicationController
  ::Sequencescape::Api::ConnectionFactory.default_url = Settings.sequencescape_api_v1

  def api_connection_options
    { url: Settings.sequencescape_api_v1, authorisation: Settings.sequencescape_authorisation, cookie: nil }
  end

  def sequencescape_api_error_handler(exception)
    raise exception
  end

  def format_errors(obj)
    if obj.errors.size > MAX_NUMBER_OF_ERROR_MESSAGES
      "#{obj.errors.map(&:message).first(MAX_NUMBER_OF_ERROR_MESSAGES).join("\n")} ..."
    else
      obj.errors.map(&:message).join("\n")
    end
  end
end

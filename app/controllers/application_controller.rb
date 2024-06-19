# frozen_string_literal: true

class ApplicationController < ActionController::Base
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
    obj.errors.map(&:message).join("\n")
  end
end

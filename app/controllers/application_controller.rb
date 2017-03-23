class ApplicationController < ActionController::Base
  protect_from_forgery
  include ::Sequencescape::Api::Rails::ApplicationController
  ::Sequencescape::Api::ConnectionFactory.default_url = Settings.sequencescape_url

  def api_connection_options
    { url: Settings.sequencescape_url, authorisation: Settings.sequencescape_authorisation, cookie: nil }
  end

  def sequencescape_api_error_handler(exception)
    raise exception
  end

end



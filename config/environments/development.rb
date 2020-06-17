# frozen_string_literal: true
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local = true

  config.eager_load = false

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true


    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :raise

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.public_file_server.enabled = true

  config.admin_email = 'example@example.com'

  # https://github.com/sanger/wrangler
  config.wrangler_url = 'http://127.0.0.1:5001/tube_rack'

  # https://github.com/sanger/lighthouse
  config.lighthouse_host = 'http://127.0.0.1:5000'

  config.logger = Logger.new(STDOUT)
  config.logger.broadcast_messages = false
end

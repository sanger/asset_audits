# frozen_string_literal: true
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.eager_load = false

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600'
  }

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :raise

  config.public_file_server.enabled = true
  config.public_file_server.headers = { 'Cache-Control' => 'public, max-age=3600' }

  config.active_support.test_order = :random

  config.admin_email = 'example@example.com'

  # https://github.com/sanger/wrangler
  config.wrangler_url = 'http://example.com/wrangle'

  # https://github.com/sanger/lighthouse
  config.lighthouse_host = 'http://127.0.0.1:5000'
end

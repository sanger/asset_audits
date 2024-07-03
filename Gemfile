# frozen_string_literal: true

# source 'https://rubygems.org'
source "http://rubygems.org"

gem "activeresource"
gem "rails", "~> 7.0.7"
gem "rake"

gem "daemons"
gem "delayed_job_active_record"
gem "formtastic"
gem "haml"
gem "json_api_client"
gem "mysql2"
gem "nokogiri"
gem "oj"
gem "sprockets-rails", "~> 3.4"
gem "uuidtools"

gem "byebug"
gem "puma"

# Manage default records
gem "record_loader"

group :development do
  gem "listen" # Hot reloading
  gem "rubocop"
  gem "rubocop-minitest"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rake"

  # Installing prettier via the ruby-gem as this project currently has no
  # other node dependencies
  gem "prettier"
end

gem "factory_bot_rails", groups: %i[test cucumber]

gem "pry", groups: %i[test cucumber development]

group :test do
  gem "mocha"
  gem "shoulda"
  gem "sinatra"
  gem "webmock"
end

group :cucumber, :test do
  gem "capybara"
  gem "cucumber-rails", require: false
  gem "database_cleaner-active_record"
  gem "launchy"
  gem "minitest"
  gem "rspec-expectations"
  gem "rspec-mocks"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "timecop"
  gem "webrick"
end

group :deployment do
  gem "exception_notification"
end

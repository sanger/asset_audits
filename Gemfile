# source 'https://rubygems.org'
source 'http://rubygems.org'

gem 'rails', '~> 5.2.0'
gem 'rake'
gem 'activeresource'

gem 'nokogiri'
gem 'formtastic'
gem 'mysql2'
gem 'uuidtools'
gem 'haml'
gem 'sequencescape-client-api', require: 'sequencescape'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'json_api_client'

gem 'byebug'
gem 'puma'

# Manage default records
gem 'record_loader'

group :development do
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'listen' # Hot reloading
end

gem 'factory_bot_rails', groups: [:test, :cucumber]

gem 'pry', groups: [:test, :cucumber, :development]

group :test do
  gem 'mocha'
  gem 'shoulda'
  gem 'webmock'
  gem 'sinatra'
end

group :cucumber, :test do
  gem 'simplecov', require: false
  gem 'capybara'
  gem 'minitest'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'timecop'
  gem 'rspec-expectations'
  gem 'rspec-mocks'
  gem 'selenium-webdriver'
  gem 'rubyzip'
  gem 'webdrivers'
end

group :deployment do
  gem 'exception_notification'
end

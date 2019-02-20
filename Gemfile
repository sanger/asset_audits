# source 'https://rubygems.org'
source 'http://rubygems.org'

gem 'rails', '~> 4.0'
gem 'rake'
gem 'activeresource'

gem 'nokogiri'
gem 'formtastic'
gem 'mysql2'
gem 'uuidtools'
gem 'curb'
gem 'haml'
gem 'sequencescape-client-api', require: 'sequencescape'
gem 'delayed_job_active_record'
gem 'json_api_client'

gem 'byebug'

group :development do
  gem 'rubocop'
end

gem 'factory_girl_rails', groups: [:test, :cucumber]

gem 'pry', groups: [:test, :cucumber, :development]

group :test do
  gem 'mocha'
  gem 'shoulda'
  gem 'webmock'
  gem 'sinatra'
end

group :cucumber do
  gem 'capybara'
  gem 'minitest'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'poltergeist'
  gem 'timecop'
  gem 'rspec-expectations'
end

group :deployment do
  gem 'thin'
  gem 'psd_logger', github: 'sanger/psd_logger'
  gem 'exception_notification'
end

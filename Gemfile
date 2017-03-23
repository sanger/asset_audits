source 'https://rubygems.org'
#source 'http://gems.github.com'

gem 'rails', '~> 4.0'
gem 'rake'
gem 'activeresource'

gem 'nokogiri'
gem "formtastic"
gem "mysql2"
gem "uuidtools"
gem "compass"
gem 'curb'
gem 'haml'
gem 'sequencescape-client-api', github: 'jamesglover/sequencescape-client-api', tag: ' rc1.3.0', require: 'sequencescape'
gem 'delayed_job_active_record'
# gem "jquery-rails"

gem "byebug"

group :development do
  gem "sinatra"
  gem 'rubocop'
end

gem "factory_girl_rails", groups: [:test,:cucumber]

group :test do
  gem "mocha"
  gem "shoulda"
end

group :cucumber do
  gem "capybara"
  gem 'minitest'
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "launchy"
  gem "timecop"
  gem "poltergeist"
end

group :deployment do
  gem 'thin'
  gem "psd_logger", github: "sanger/psd_logger"
  gem 'exception_notification'
end
# Needed for the new asset pipeline

gem 'sass-rails'
gem 'uglifier'
gem 'therubyracer'

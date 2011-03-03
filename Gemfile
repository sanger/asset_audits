source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '3.0.4'

gem 'nokogiri'
gem "formtastic"
gem "mysql"
gem "uuidtools"
gem "compass"
gem 'curb'
gem 'haml'
gem 'sequencescape-client-api', :git => 'http://github.com/sanger/sequencescape-client-api.git', :require => 'sequencescape', :ref => 'c92f4a9'

group :development do
   gem "sinatra"
   gem 'ruby-debug19'
   gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :test do
  gem "capybara"
  gem "cucumber-rails"
  gem "database_cleaner"
  gem "factory_girl"
  gem "launchy"
  gem "mocha"
  gem "shoulda"
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :deployment do
  gem 'thin'
end

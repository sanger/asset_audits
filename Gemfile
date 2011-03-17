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
gem 'sequencescape-client-api', :git => 'http://github.com/sanger/sequencescape-client-api.git', :require => 'sequencescape', :ref => '8c30df3'
gem 'delayed_job'

gem 'sqlite3-ruby', '~> 1.2.0', :require => 'sqlite3', :groups => [:development, :test, :cucumber]

group :development do
   gem "sinatra"
   gem 'ruby-debug19'
end

group :test do
  gem "capybara"
  gem "cucumber-rails"
  gem "database_cleaner"
  gem "factory_girl"
  gem "launchy"
  gem "mocha"
  gem "shoulda"
end

group :deployment do
  gem 'thin'
end

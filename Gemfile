source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '3.0.7'

gem 'nokogiri'
gem "formtastic"
gem "mysql"
gem "uuidtools"
gem "compass"
gem 'curb'
gem 'haml'
gem 'sequencescape-client-api', :git => 'git+ssh://git@github.com/sanger/sequencescape-client-api.git', :require => 'sequencescape'
gem 'delayed_job'
gem "jquery-rails"
gem 'exception_notification'

gem 'sqlite3-ruby', '~> 1.2.0', :require => 'sqlite3', :groups => [:development, :test, :cucumber]

group :development do
  gem "sinatra"
  gem 'ruby-debug19', :require => 'ruby-debug', :groups => [:development, :test, :cucumber]
end

group :test do
  gem "spork"
  gem "capybara"
  gem "cucumber-rails"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "launchy"
  gem "mocha"
  gem "shoulda"
end

group :deployment do
  gem 'thin'
  gem "psd_logger", :git => "git+ssh://git@github.com/sanger/psd_logger.git"
end

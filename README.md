# Asset Audits

This application allows you to add audits to assets. Its intended to be used in the Lab to track
who did what, when they did it, what they did it to and what lab instrument they used. It requires
Sequencescape.

## Requirements

* phantomjs (for testing)

## Getting started

1. Install the required version of ruby - look for the version in the `.ruby-version` file
1. Install bundler: `gem install bundler`
1. Install the required gems: `bundle install`
1. Migrate the database: `bundle exec rake db:setup`

## Testing

To run the tests, execute the following commands:

    RAILS_ENV=test bundle exec rake db:create db:schema:load
    bundle exec rake db:test:prepare
    export CUCUMBER_FORMAT=progress

    bundle exec rake

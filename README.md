# Asset Audits

This application allows you to add audits to assets. Its intended to be used in the Lab to track
who did what, when they did it, what they did it to and what lab instrument they used. It requires
Sequencescape.

## Requirements

### Software

* phantomjs (for testing)

### Running applications

* Sequencescape is required to authenticate against
* tube-rack-wrangler is required if you want automatic sample creation in Sequencescape

## Getting started

1. Install the required version of ruby - look for the version in the `.ruby-version` file
1. Install bundler: `gem install bundler`
1. Install the required gems: `bundle install`
1. Migrate the database: `bundle exec rake db:setup`
1. Configure the settings for the environment of interest in `config/settings`
1. Run the server: `bundle exec rails s`

## Testing

To run the tests, execute the following commands:

    RAILS_ENV=test bundle exec rake db:create db:schema:load
    bundle exec rake db:test:prepare
    export CUCUMBER_FORMAT=progress

    bundle exec rake

## Miscellaneous

Had trouble getting the `mysql2` gem working. I downgraded the version of `mysql2` which fixed my
issue. In the `Gemfile` file:

```ruby
gem 'mysql2', '~> 0.4.0'
```

You might get the following error when hitting 'Submit' on the process_plates/new page:
`Sequencescape::Api::ResourceNotFound Exception: ["UUID does not exist"]`
Follow these steps:
- note what UUID is listed for search_find_source_assets_by_destination_barcode in development.yml
- look in your local Sequencescape database
- table 'searches' should have a row called 'Find source assets by destination asset barcode'
- table 'uuids' should have a row pointing to the search record, with the uuid from development.yml, and resource_type = 'Search'
- In future, we should create this automatically in a rake task, like Limber does
# Asset Audits

This application allows you to add audits to assets. It is intended to be used in the lab to track
who did what, when they did it, what they did it to and what lab instrument they used. It requires
Sequencescape.

## Requirements

### Running applications

- [Sequencescape](https://github.com/sanger/sequencescape/) is required to authenticate against

## Getting started

1. If you are working on a Macintosh:
   1. Install [Homebrew](https://brew.sh)
   1. Install `shared-mime-info` with `brew install shared-mime-info`. This is
      needed by one of the required Gems in this project.
1. Install the required version of ruby - look for the version in the `.ruby-version` file
1. Install bundler: `gem install bundler`
1. Install the required gems: `bundle install`
1. Migrate/setup the database: `bundle exec rake db:setup`
1. Configure the settings for the environment of interest in: `config/settings`
1. Run the server: `bundle exec rails server`

## Testing

To run the tests, execute the following commands:

    RAILS_ENV=test bundle exec rake db:create db:schema:load
    bundle exec rake db:test:prepare
    export CUCUMBER_FORMAT=progress

    bundle exec rake

To run a single test:

    bundle exec rake test TEST=<test_file_path>

## Linting and formatting

Rubocop is used for linting.

```shell
bundle exec rubocop
```

Prettier is used for formatting.

```shell
bundle exec rbprettier --check . --ignore-unknown
```

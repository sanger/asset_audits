# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProcessTracking
  class Application < Rails::Application
    config.load_defaults 5.1
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.name = 'AssetAudits'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.assets.enabled = true
    config.assets.version = '1.0'

    require './lib/deployed_version'

    def self.application_string
      Deployed::VERSION_STRING
    end

    def self.commit_information
      Deployed::VERSION_COMMIT
    end

    def self.repo_url
      Deployed::REPO_URL
    end

    def self.host_name
      Deployed::HOSTNAME
    end

    def self.release_name
      Deployed::RELEASE_NAME
    end
  end
end

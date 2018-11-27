# frozen_string_literal: true

class Sequencescape::Api::V2::Base < JsonApiClient::Resource
  # set the api base url in an abstract base class
  self.site = Settings.sequencescape_api_v2
end

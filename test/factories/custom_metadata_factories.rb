# frozen_string_literal: true

FactoryBot.define do
  factory :custom_metadatum_collection, class: Sequencescape::Api::V2::CustomMetadatumCollection do
    metadata { {} }

    skip_create
  end
end

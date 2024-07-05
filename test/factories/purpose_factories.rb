# frozen_string_literal: true

FactoryBot.define do
  # Basic v2 Purpose
  factory :v2_purpose, class: Sequencescape::Api::V2::Purpose do
    skip_create
    name { "Example Purpose" }
    uuid { "example-purpose-uuid" }
  end
end

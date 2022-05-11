# frozen_string_literal: true

class Sequencescape::Api::V2::Labware < Sequencescape::Api::V2::Base
  def self.table_name
    'labware'
  end

  has_one :purpose
end

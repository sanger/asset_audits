# frozen_string_literal: true

class TestSequencescapeApi
  class CreatedStore
    attr_reader :created

    def initialize
      @created = []
    end

    def create!(params)
      @created << params
    end
  end

  attr_accessor :plate
  attr_accessor :barcode
  attr_accessor :barcode_to_results

  def initialize(barcode_to_results)
    @barcode_to_results = barcode_to_results
  end

  def asset_audit
    @asset_audit ||= CreatedStore.new
  end

  def search
    self
  end

  def find(_search_uuid)
    self
  end

  def all(_plate, options = {})
    @barcode_to_results[options[:barcode]] || []
  end
end

# frozen_string_literal: true

class TestSearchResult
  attr_accessor :barcode, :uuid

  def initialize(machine_barcode, uuid: 'uuid')
    # Not what actually happens, but it'll work for our purposes
    encoded_barcode = machine_barcode.bytes.map { |b| (b % 48).to_s }.join
    @uuid = uuid
    @barcode = OpenStruct.new(ean13: encoded_barcode, machine: machine_barcode) # rubocop:todo Style/OpenStructUse
  end
end

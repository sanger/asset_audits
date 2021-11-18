# frozen_string_literal: true

class TestSearchResult
  MockBarcode = Struct.new(:ean13, :machine)

  attr_accessor :barcode, :uuid

  def initialize(machine_barcode, uuid: 'uuid')
    # Not what actually happens, but it'll work for our purposes
    encoded_barcode = machine_barcode.bytes.map { |b| (b % 48).to_s }.join
    @uuid = uuid
    @barcode = MockBarcode.new(encoded_barcode, machine_barcode)
  end
end

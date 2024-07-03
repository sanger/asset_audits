# frozen_string_literal: true

Given(/^Sequencescape has a plate with barcode "([^"]*)"$/) do |barcode|
  plate_json = {
    data: [
      { id: "1", type: "plates", links: { self: "http://sequencescape/api/v2/plates/1" }, attributes: { uuid: "00000000-1111-2222-3333-444444555555" } }
    ]
  }

  stub_request(:get, "http://sequencescape/api/v2/plates?filter%5Bbarcode%5D%5B0%5D=#{barcode}").to_return_json(status: 200, body: plate_json)
end

module MockSequencescapeV2
  module_function

  def mock_get_plate(barcode, attributes)
    plate_json = {
      data: [
        { id: "1", type: "plates", links: { self: "http://sequencescape/api/v2/plates/1" }, attributes: attributes }
      ]
    }

    stub_request(:get, "http://sequencescape/api/v2/plates?filter%5Bbarcode%5D%5B0%5D=#{barcode}").with(
      headers: {
        "Accept" => "application/vnd.api+json",
        "Content-Type" => "application/vnd.api+json",
        "X-Sequencescape-Client-Id" => "cucumber"
      }
    ).to_return_json(status: 200, body: plate_json)
  end

  def mock_post_asset_audit(body)
    stub_request(:post, "http://sequencescape/api/v2/asset_audits").with(
      body:,
      headers: {
        "Accept" => "application/vnd.api+json",
        "Content-Type" => "application/vnd.api+json",
        "X-Sequencescape-Client-Id" => "cucumber"
      }
    ).to_return_json(status: 200, body: {})
  end
end

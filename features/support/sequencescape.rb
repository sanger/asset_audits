# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), "fake_sinatra_service.rb"))

class FakeSequencescapeService < FakeSinatraService
  def initialize(*args, &)
    super
    Settings.settings["sequencescape_api_v1"] = "http://#{host}:#{port}/api/1/"
  end

  def clear
    @search_results = {}
  end

  def service
    Service
  end

  def search_results
    @search_results ||= {}
  end

  def search_result(search_uuid, barcode, result_json)
    search_results[search_uuid] = {} if search_results[search_uuid].nil?
    search_results[search_uuid][barcode] = result_json
  end

  def find_result_json_by_search_uuid(search_uuid, barcode)
    return nil unless search_results[search_uuid]

    search_results[search_uuid][barcode]
  end

  def load_file(filename)
    base_path = File.join(File.dirname(__FILE__), "..", "data")
    json = File.read(File.join(base_path, filename).to_s)
    replace_host_and_port(json)
  end

  def replace_host_and_port(json)
    json.gsub("locahost", host).gsub("3000", port.to_s)
  end

  class Service < FakeSinatraService::Base
    get("/api/1/") do
      FakeSequencescapeService.instance
      json = FakeSequencescapeService.instance.load_file("index")
      headers("Content-Type" => "application/json")
      body(json)
    end

    post "/api/1/asset_audits" do
      status(201)
      json = FakeSequencescapeService.instance.load_file("create_asset_audit")
      headers("Content-Type" => "application/json")
      body(json)
    end

    get("/api/1/#{Settings.search_find_assets_by_barcode}") do
      json = FakeSequencescapeService.instance.load_file("search_find_asset_by_barcode")
      headers("Content-Type" => "application/json")
      body(json)
    end

    post("/api/1/#{Settings.search_find_assets_by_barcode}/all") do
      status(300)
      json =
        FakeSequencescapeService.instance.find_result_json_by_search_uuid(
          Settings.search_find_assets_by_barcode,
          ActiveSupport::JSON.decode(request.body.read)["search"]["barcode"]
        )
      json = FakeSequencescapeService.instance.load_file("search_results_for_find_asset_by_barcode") if json.blank?
      headers("Content-Type" => "application/json")
      body(json)
    end

    get("/api/1/*") { status(200) }
  end
end

FakeSequencescapeService.install_hooks(self, "@sequencescape_service")

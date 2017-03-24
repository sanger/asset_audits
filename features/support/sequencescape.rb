require File.expand_path(File.join(File.dirname(__FILE__), 'fake_sinatra_service.rb'))

class FakeSequencescapeService < FakeSinatraService
  def initialize(*args, &block)
    super
    Settings.settings['sequencescape_url'] = "http://#{host}:#{port}/api/1/"
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
    json = IO.read(File.join(base_path, filename).to_s)
    updated_json = replace_host_and_port(json)

    updated_json
  end

  def replace_host_and_port(json)
    json.gsub(/locahost/, host).gsub(/3000/, "#{port}")
  end


  class Service < FakeSinatraService::Base
    get('/api/1/') do
      FakeSequencescapeService.instance
      json = FakeSequencescapeService.instance.load_file('index')
      headers('Content-Type' => 'application/json')
      body(json)
    end

    post '/api/1/asset_audits' do
      status(201)
      json = FakeSequencescapeService.instance.load_file('create_asset_audit')
      headers('Content-Type' => 'application/json')
      body(json)
    end

    get("/api/1/#{Settings.search_find_assets_by_barcode}") do
      json = FakeSequencescapeService.instance.load_file('search_find_asset_by_barcode')
      headers('Content-Type' => 'application/json')
      body(json)
    end

    post("/api/1/#{Settings.search_find_assets_by_barcode}/all") do
      status(300)
      json = FakeSequencescapeService.instance.find_result_json_by_search_uuid(Settings.search_find_assets_by_barcode, ActiveSupport::JSON.decode(request.body.read)['search']['barcode'])
      if json.blank?
        json = FakeSequencescapeService.instance.load_file('search_results_for_find_asset_by_barcode')
      end
      headers('Content-Type' => 'application/json')
      body(json)
    end

    get("/api/1/#{Settings.search_find_source_assets_by_destination_barcode}") do
      json = FakeSequencescapeService.instance.load_file('search_find_source_assets_by_destination_barcode')
      headers('Content-Type' => 'application/json')
      body(json)
    end

    post("/api/1/#{Settings.search_find_source_assets_by_destination_barcode}/all") do
      status(300)
      json = FakeSequencescapeService.instance.find_result_json_by_search_uuid(Settings.search_find_source_assets_by_destination_barcode, ActiveSupport::JSON.decode(request.body.read)['search']['barcode'])
      headers('Content-Type' => 'application/json')
      body(json)
    end

    get("/api/1/*") do
      status(200)
    end
  end
end

FakeSequencescapeService.install_hooks(self, '@sequencescape_service')

require File.expand_path(File.join(File.dirname(__FILE__), 'fake_sinatra_service.rb'))

class FakeSequencescapeService < FakeSinatraService
  def initialize(*args, &block)
    super
    Settings.settings['sequencescape_url'] = "http://#{host}:#{port}/api/1/"
    
  end

  def clear
  end
  
  def service
    Service
  end
  
  def load_file(filename)
    base_path = File.join(File.dirname(__FILE__), "..", "data")
    json =  IO.read(File.join(base_path, filename).to_s)
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
      body(json)
    end
  end
end

FakeSequencescapeService.install_hooks(self, '@sequencescape_service')

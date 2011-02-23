require File.expand_path(File.join(File.dirname(__FILE__), 'fake_sinatra_service.rb'))

class FakeUserBarcodeService < FakeSinatraService
  def initialize(*args, &block)
    super
    Settings.settings['user_barcode_url'] = "http://#{host}:#{port}"
    UserBarcode::UserBarcode.site= Settings.user_barcode_url
    
  end

  def user_barcodes
    @user_barcodes ||= {}
  end

  def clear
    @user_barcodes = {}
  end

  def user_barcode(user, barcode)
    self.user_barcodes[barcode] = user
  end
  
  def find_user_by_barcode(barcode)
    self.user_barcodes[barcode]
  end
  
  def service
    Service
  end

  class Service < FakeSinatraService::Base
    get('/user_barcodes/lookup_scanned_barcode.xml') do
      user = FakeUserBarcodeService.instance.find_user_by_barcode(params[:barcode])
      xml  = {'login' =>  user }
      headers('Content-Type' => 'application/xml')
      body(xml.to_xml)
    end
  end
end

FakeUserBarcodeService.install_hooks(self, '@user_barcode_service')

class ProcessPlate < ActiveRecord::Base
  include ProcessPlateValidation
  attr_accessor :api
  # remove active record
  
  belongs_to :instrument_process

  #after_create :create_events
  
  def user_login
    UserBarcode::UserBarcode.find_username_from_barcode(self.user_barcode)
  end
  
  def barcodes
    source_plates.scan(/\d+/).map{ |plate| plate }
  end
  
  def instrument
    Instrument.find_by_barcode(instrument_barcode)
  end
  
  def search_resource
    api.search.find(Settings.search_find_assets_by_barcode)
  end
  
  def asset_uuids_from_plate_barcodes
    asset_search_results_from_plate_barcodes.flatten.map(&:uuid)
  end
  
  def asset_search_results_from_plate_barcodes
    barcodes.map do |barcode| 
      search_resource.all(api.plate, :barcode => barcode)
    end
  end
  
  def create_audits
    asset_uuids_from_plate_barcodes.each do |asset_uuid|
      api.asset_audit.create!(
        :key => instrument_process.key,
        :message => "Process '#{instrument_process.name}' performed on instrument #{instrument.name}",
        :created_by => user_login, 
        :asset => asset_uuid
      )
    end
  end
     
end

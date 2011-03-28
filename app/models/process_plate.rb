class ProcessPlate < ActiveRecord::Base
  include ProcessPlateValidation
  attr_accessor :api
  attr_accessor :user_name
  attr_accessor :witness_name
  attr_accessor :instrument_used
  attr_accessor :asset_search_results
  # remove active record
  
  belongs_to :instrument_process

  #after_create :create_events
  
  def user_login
    return self.user_name unless self.user_name.blank?
    self.user_name = UserBarcode::UserBarcode.find_username_from_barcode(self.user_barcode)
  end
  
  def witness_login
    return self.witness_name unless self.witness_name.blank?
    self.witness_name = UserBarcode::UserBarcode.find_username_from_barcode(self.witness_barcode)
  end
  
  def barcodes
    source_plates.scan(/\d+/).map{ |plate| plate }
  end
  
  def instrument
    return self.instrument_used unless self.instrument_used.blank?
    self.instrument_used = Instrument.find_by_barcode(instrument_barcode)
  end
  
  def search_resource
    api.search.find(Settings.search_find_assets_by_barcode)
  end
  
  def asset_uuids_from_plate_barcodes
    asset_search_results_from_plate_barcodes.flatten.map(&:uuid)
  end
  
  def asset_search_results_from_plate_barcodes
    return self.asset_search_results unless self.asset_search_results.blank?
    self.asset_search_results = barcodes.map do |barcode| 
      search_resource.all(api.plate, :barcode => barcode)
    end
  end
  
  def create_audits
    self.api = Sequencescape::Api.new({ :cookie => Settings.sequencescape_key, :url => Settings.sequencescape_url }) if self.api.nil?
      
    asset_uuids_from_plate_barcodes.each do |asset_uuid|
      create_remote_audit(asset_uuid)
    end
  end
  handle_asynchronously :create_audits
  
  def create_remote_audit(asset_uuid)
    api.asset_audit.create!(
      :key => instrument_process.key,
      :message => "Process '#{instrument_process.name}' performed on instrument #{instrument.name}",
      :created_by => user_login, 
      :asset => asset_uuid,
      :witnessed_by => witness_name
    )
  end
     
end

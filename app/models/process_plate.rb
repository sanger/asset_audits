class ProcessPlate < ActiveRecord::Base
  include ProcessPlateValidation

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
  
  def asset_uuids_from_plate_barcodes
    barcodes.map{ |barcode| Warehouse::Plate.uuid_from_barcode(barcode) }
  end
  
  def create_audits(api)
    asset_uuids_from_plate_barcodes.each do |asset_uuid|
      api.asset_audit.create!(
        :key => instrument_process.key,
        :message => "Plate #{asset_uuid} on instrument #{instrument.name} had process #{instrument_process.name} performed",
        :created_by => user_login, 
        :asset => asset_uuid
      )
    end
  end
     
end

module  ProcessPlateValidation
  def self.included(base)
    base.class_eval do
      validate :user_login_exists
      validate :instrument_exists
      validate :plates_exists
      validate :process_on_instrument, :if => :instrument?
    end
  end

  def user_login_exists
    errors.add(:user_barcode, "Invalid user") if user_login.nil?
  end
  
  def instrument_exists
    errors.add(:instrument, "Invalid instrument barcode") if instrument.nil?
  end
  
  def plates_exists
    found_barcodes = asset_search_results_from_plate_barcodes.flatten.map(&:barcode)
    barcodes.each do |barcode|
     errors.add(:source_plates, "Invalid plate barcodes")  unless found_barcodes.include?(Barcode.split_barcode(barcode)[1].to_s)
    end
    errors.add(:source_plates, "Invalid plate barcodes") if asset_uuids_from_plate_barcodes.include?(nil)
  end
  
  def process_on_instrument
    errors.add(:instrument_process, "Invalid process for instrument") unless instrument.instrument_processes.include?(instrument_process)
  end
  
  def instrument?
    return true if instrument
    false
  end
  
end
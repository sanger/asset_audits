class UserBarcode::UserBarcode < ActiveResource::Base
  self.site = Settings.user_barcode_url
  
  def self.find_username_from_barcode(barcode)
    user_details = get(:lookup_scanned_barcode, :barcode => barcode)
    user_details ? user_details['login'] : nil
  end
end


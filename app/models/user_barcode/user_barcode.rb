class UserBarcode::UserBarcode < ActiveResource::Base
  self.site = Settings.user_barcode_url
  self.format = ActiveResource::Formats::XmlFormat

  def self.find_username_from_barcode(barcode)
    begin
      user_details = get(:lookup_scanned_barcode, barcode: barcode)
    rescue ActiveResource::ServerError => exception
      # For some reason the user barcode service returns a 500 Not Found
      # rather than the more sensible 404. We catch this exception
      # and re-raise it if it looks like something else
      raise exception unless exception.response.message == 'Not Found'
      user_details = false
    end
    user_details ? user_details['login'] : nil
  end
end

class Warehouse::Plate < ActiveRecord::Base
  include Warehouse::Base
  set_table_name "plates"
  
  def self.stock_plate(barcode)
    where(:barcode_prefix => "DN", :barcode => barcode).first
  end
  
  def self.uuid_from_barcode(raw_barcode)
    prefix = Barcode.prefix_to_human(Barcode.split_barcode(raw_barcode)[0])

    barcode_number = Barcode.split_barcode(raw_barcode)[1]
    plate = self.where(:barcode_prefix => prefix, :barcode => barcode_number).first

    return plate.uuid if plate
    
    nil    
  end
  
end

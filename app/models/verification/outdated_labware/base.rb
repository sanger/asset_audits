class Verification::OutdatedLabware::Base < Verification::WithoutBedValidations
  include Verification::BedVerification
  validates_with Verification::Validator::OutdatedPlatesScanned

  attr_accessor :plate_barcodes_to_destroy

  attr_accessor :messages

  def add_message(facility, message)
    @messages = {} if @messages.nil?
    if @messages[facility].nil?
      @messages[facility]=[message]
    else
      @messages[facility].push(message)
    end
  end

  def self.partial_name
    "outdated_labware"
  end

  def scanned_values
    [@attributes[:scanned_values]].flatten.map do |s|
      s.split(/\s/).reject(&:blank?)
    end.flatten
  end

  def get_search_instance
    if @all_searches.nil?
      @all_searches = api.search.all
      @search_instance = @all_searches.detect {|search| search.name.match(/Find assets by barcode/)}
    else
      # We create a new search instance of our searching facet in every request
      @search_instance = api.search.find(@search_instance.uuid)
    end
    @search_instance
  end

  def plates_from_barcodes(barcodes)
    get_search_instance.all(api.plate,
      :barcode => barcodes).reduce({}) do |memo, plate|
      memo[plate.barcode.ean13] = plate
      memo
    end
  end

  def parse_source_and_destination_barcodes(barcodes)
    plate_barcodes_to_destroy
  end
end

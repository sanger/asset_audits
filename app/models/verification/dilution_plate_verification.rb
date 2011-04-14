class Verification::DilutionPlateVerification < Verification::Base
  self.source_beds      = ['P2','P5', 'P8', 'P11']
  self.destination_beds = ['P3','P6', 'P9', 'P12']

  def self.partial_name
    "dilution_plate"
  end
  
  def self.javascript_partial_name
    "dilution_plate_javascript"
  end

  def validate_and_create_audits?(api, params)
    return false unless plates_scanned?(params[:robot])
    
    params[:robot].each do |bed_name, position|
      return false unless valid_bed_with_errors?(bed_name, position[:bed], position[:plate])
    end
    return false unless valid_source_and_destination_plates?(api, params[:robot])
    
    params[:source_plates] = parse_source_and_destination_barcodes(params[:robot]).flatten.join(" ")
    return super(api, params)
  end
  
  def plates_scanned?(scanned_values)
    scanned_plate_barcodes = parse_source_and_destination_barcodes(scanned_values).flatten
    if scanned_plate_barcodes.empty?
      errors.add(:bed, "No plates scanned")
      return false
    end

    true
  end

  def parse_source_and_destination_barcodes(scanned_values)
    source_and_destination_barcodes = []
    self.source_beds.each_with_index do |source_bed, index|
      source_barcode = scanned_values[source_bed.downcase.to_sym][:plate]
      destination_barcode = scanned_values[destination_beds[index].downcase.to_sym][:plate]
      next if source_barcode.blank? && destination_barcode.blank?
      source_and_destination_barcodes << [ source_barcode, destination_barcode ]
    end

    source_and_destination_barcodes
  end

  def valid_source_and_destination_plates?(api, scanned_values)
    parse_source_and_destination_barcodes(scanned_values).each do |source_barcode, destination_barcode|
      return false unless valid_destination_barcode?(destination_barcode)
      search_resource = api.search.find(Settings.search_find_source_assets_by_destination_barcode)
      search_results = search_resource.all(api.plate, :barcode => destination_barcode)
      return false unless valid_source_barcode?(source_barcode, search_results)
    end

    true
  end
  
  def valid_destination_barcode?(destination_barcode)
    if destination_barcode.blank?
      errors.add(:bed, "Invalid destination plate layout")
      return false
    end
    
    true
  end
  
  def valid_source_barcode?(source_barcode, search_results)
    unless source_barcodes_from_search_results(search_results).include?(source_barcode)
      errors.add(:bed, "Invalid source plate layout")
      return false 
    end
    
    true
  end
  
  def source_barcodes_from_search_results(search_results)
    search_results.flatten.map(&:ean13_barcode)
  end
  
  def valid_bed_with_errors?(bed_name, bed_barcode, plate_barcode)
    unless valid_bed?(bed_name, bed_barcode, plate_barcode)
      errors.add(:bed, "Invalid layout") 
      return false
    end
    
    true
  end

  def valid_bed?(bed_name, bed_barcode, plate_barcode)
    return true if bed_barcode.blank? && plate_barcode.blank?
    if ( ! bed_barcode.blank? ) && ( ! plate_barcode.blank? )
      bed = instrument.beds.select{ |bed| bed.name.downcase == bed_name }.first
      return false if bed.nil?
      return false if bed.barcode != bed_barcode

      return true
    end

   false
  end


end


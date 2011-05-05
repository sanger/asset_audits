class Verification::Validator::SequenomPlateOrder < ActiveModel::Validator
  def validate(record)
    record.destination_beds.each do |destination_bed|
      destination_barcode =  record.scanned_values[destination_bed.downcase.to_sym][:plate]
      next if destination_barcode.blank?
      search_resource = record.api.search.find(Settings.search_find_assets_by_barcode)
      check_source_plate_order_for_destination_plate(destination_barcode, search_resource, record)
    end
  end

  private
  def check_source_plate_order_for_destination_plate(destination_barcode, search_resource, record)
      search_results = search_resource.all(record.api.plate, :barcode => destination_barcode)
      check_source_barcode_order(search_results, record)
      check_destination_plate_size(search_results, record)
      
      true
  end

  def check_destination_plate_size(search_results, record)
    destination_plate_size = plate_sizes_from_search_results(search_results).first
    if destination_plate_size.to_i != 384
      record.errors[:base] << "Invalid plate size, it must be 384"
    end
  end

  def check_source_barcode_order(search_results, record)
    destination_plate_name = source_names_from_search_results(search_results).first
    expected_source_barcode_order = source_barcodes(destination_plate_name)
    actual_source_barcode_order = strip_plate_id_from_ean13_barcodes(scanned_source_ean13_barcodes(record))

    if expected_source_barcode_order != actual_source_barcode_order
      record.errors[:base] << "Invalid source plate order"
    end
  end

  def source_names_from_search_results(search_results)
    search_results.flatten.map(&:name)
  end
  
  def plate_sizes_from_search_results(search_results)
    search_results.flatten.map(&:size)
  end

  def source_barcodes(name)
    label_match = name.match(/^([^\d]+)(\d+)?_(\d+)?_(\d+)?_(\d+)?_(\d+)$/)
    [label_match[2], label_match[3], label_match[4], label_match[5]]
  end

  def scanned_source_ean13_barcodes(record)
    source_barcodes = []
    record.source_beds.each do |source_bed|
      source_barcode = record.scanned_values[source_bed.downcase.to_sym][:plate]
      if source_barcode.blank?
        source_barcodes << nil
      else
        source_barcodes << source_barcode
      end
    end

    source_barcodes
  end

  def strip_plate_id_from_ean13_barcodes(ean13_barcodes)
    plate_ids = []
    ean13_barcodes.each do |barcode|
      plate_id = Barcode.split_barcode(barcode)[1]
      if plate_id.blank? || plate_id == 0
        plate_ids << nil
      else
        plate_ids << plate_id.to_s
      end
    end

    plate_ids
  end

end



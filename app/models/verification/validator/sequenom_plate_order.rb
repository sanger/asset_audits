class Verification::Validator::SequenomPlateOrder < ActiveModel::Validator
  def validate(record)
    record.destination_beds.map do |destination_bed|
      record.scanned_values[destination_bed.downcase.to_sym][:plate]
    end.select do |destination_barcode|
      not destination_barcode.blank?
    end.tap do |barcodes|
      # NOTE: Probably these can be ungrouped but to maintain some resemblance of the original
      # version I've left them being grouped by EAN13 barcode.
      search_resource = record.api.search.find(Settings.search_find_assets_by_barcode)
      check_source_plate_order_for_destination_plate(
        search_resource.all(record.api.plate, :barcode => barcodes),
        record
      )
    end
  end

  private

  def check_source_plate_order_for_destination_plate(plates, record)
    check_source_barcode_order(plates, record)
    check_destination_plate_size(plates, record)

    true
  end

  def check_destination_plate_size(search_results, record)
    destination_plate_size = search_results.first.size

    record.errors[:base] << "Invalid plate size (#{destination_plate_size}), it must be 384" if destination_plate_size.to_i != 384
  end

  def check_source_barcode_order(search_results, record)
    destination_plate_name = search_results.first.name
    expected_source_barcode_order = source_barcodes(destination_plate_name)
    actual_source_barcode_order = strip_plate_id_from_ean13_barcodes(scanned_source_ean13_barcodes(record))

    record.errors[:base] << "Invalid source plate order" if expected_source_barcode_order != actual_source_barcode_order
  end

  def source_barcodes(name)
    label_match = name.match(/^([^\d]+)(\d+)?_(\d+)?_(\d+)?_(\d+)?_(\d+)$/) or return []
    [label_match[2], label_match[3], label_match[4], label_match[5]]
  end

  def scanned_source_ean13_barcodes(record)
    record.source_beds.map do |source_bed|
      source_barcode = record.scanned_values[source_bed.downcase.to_sym][:plate]
      source_barcode.blank? ? nil : source_barcode
    end
  end

  def strip_plate_id_from_ean13_barcodes(ean13_barcodes)
    ean13_barcodes.map do |barcode|
      plate_id = Barcode.split_barcode(barcode)[1]
      (plate_id.blank? || plate_id == 0) ? nil : plate_id.to_s
    end
  end
end



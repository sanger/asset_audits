Given /^instrument "([^"]*)" has a bed with name "([^"]*)" barcode "([^"]*)" and number (\d+)$/ do |instrument_name, bed_name, bed_barcode, bed_number|
  instrument = Instrument.find_by_name(instrument_name)
  bed = Bed.create!(:name => bed_name, :barcode => bed_barcode, :bed_number => bed_number)
  instrument.beds << bed
end


Given /^search with UUID "([^"]*)" returns the following JSON:$/ do |search_uuid, returned_json|
  FakeSequencescapeService.instance.search_result(search_uuid, returned_json)
end
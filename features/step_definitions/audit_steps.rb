Given /^user "([^"]*)" with barcode '(\d+)' exists$/ do |user_name, barcode|
  FakeUserBarcodeService.instance.user_barcode(user_name,barcode)
end

Given /^I have a "([^"]*)" instrument with barcode "([^"]*)"$/ do |instrument_name, instrument_barcode|
  Instrument.create!(:name => instrument_name, :barcode => instrument_barcode)
end

Given /^I have a process "([^"]*)" as part of the "([^"]*)" instrument$/ do |process_name, instrument_name|
  instrument = Instrument.find_by_name(instrument_name)
  instrument_process = InstrumentProcess.create!(:name => process_name, :key => process_name.gsub(/ /,'_'))
  instrument.instrument_processes << instrument_process
end

Given /^I have a plate with UUID "([^"]*)" and barcode "([^"]*)"$/ do |uuid_value, raw_barcode|
  barcode_prefix = Barcode.prefix_to_human(Barcode.split_barcode(raw_barcode)[0])
  barcode_number = Barcode.split_barcode(raw_barcode)[1]
  Warehouse::Plate.create!(:barcode => barcode_number, :barcode_prefix => barcode_prefix , :uuid => uuid_value)
end
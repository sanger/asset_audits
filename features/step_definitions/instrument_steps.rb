
def tableish(finder)
  table = find(finder)
  table.all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
end

Given /^I have an instrument "([^"]*)" with barcode "([^"]*)"$/ do |name, barcode|
  Instrument.create!(name: name, barcode: barcode)
end

Then /^the list of (instruments|processes|beds) should look like:$/ do |name, expected_table|
  expected_table.diff!(table(tableish("##{name}")))
end

Given /^I have a process "([^"]*)" with key "([^"]*)"$/ do |name, key|
  InstrumentProcess.create!(name: name, key: key)
end

Then /^the instrument process table should be:$/ do |expected_table|
  expected_table.diff!(table(tableish('#instrument_processes')))
end

Given /^instrument "([^"]*)" has process "([^"]*)"$/ do |instrument_name, process_name|
  instrument = Instrument.find_by_name(instrument_name)
  process = InstrumentProcess.find_by_name(process_name)
  instrument.instrument_processes << process
end

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

Then /^I wait (\d+) seconds?$/ do |seconds|
  sleep(seconds.to_i)
end


When /^(?:|I )fill in AJAX field "([^"]*)" with "([^"]*)"(?: within "([^"]*)")?$/ do |field, value, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
    id = "#" + find_field(field)[:id]
    page.execute_script("$('#{id}').trigger('change');")
  end
end

Given /^I have a process "([^"]*)" as part of the "([^"]*)" instrument which requires a witness$/ do |process_name, instrument_name|
  Given %Q{I have a process "#{process_name}" as part of the "#{instrument_name}" instrument}
  instrument = Instrument.find_by_name(instrument_name)
  process = InstrumentProcess.find_by_name(process_name)
  process_link = instrument.instrument_processes_instruments.select{ |process|  process.instrument_process_id == process.id }.first
  process_link.update_attributes!( :witness => true )
end

Then /^wait (\d+) seconds$/ do |time_seconds|
  sleep(time_seconds.to_i)
end

When /^(?:|I )select "([^"]*)" from AJAX dropdown "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    select(value, :from => field)
    id = "#" + find_field(field)[:id]
    page.execute_script("$('#{id}').trigger('change');")
  end
end

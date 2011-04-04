Given /^instrument "([^"]*)" has a bed with name "([^"]*)" barcode "([^"]*)" and number (\d+)$/ do |instrument_name, bed_name, bed_barcode, bed_number|
  instrument = Instrument.find_by_name(instrument_name)
  bed = Bed.create!(:name => bed_name, :barcode => bed_barcode, :bed_number => bed_number)
  instrument.beds << bed
end

Then /^the submit button should be disabled$/ do
  pending # express the regexp above with the code you wish you had
end
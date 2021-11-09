# frozen_string_literal: true

Given(/^user "([^"]*)" with barcode '(\w+)' exists$/) do |user_name, barcode|
  FakeUser.instance.user_barcode(user_name, barcode)
end

Given(/^I have a "([^"]*)" instrument with barcode "([^"]*)"$/) do |instrument_name, instrument_barcode|
  Instrument.create!(name: instrument_name, barcode: instrument_barcode)
end

Given(/^I have a process "([^"]*)" as part of the "([^"]*)" instrument$/) do |process_name, instrument_name|
  instrument = Instrument.find_by(name: instrument_name)
  instrument_process = InstrumentProcess.create!(name: process_name, key: process_name.tr(' ', '_'))
  instrument.instrument_processes << instrument_process
end

Then(/^(?:|I )wait (\d+) seconds?$/) do |seconds|
  sleep(seconds.to_i)
end

When(/^(?:|I )fill in AJAX field "([^"]*)" with "([^"]*)"(?: within "([^"]*)")?$/) do |field, value, selector|
  with_scope(selector) do
    fill_in(field, with: value)
    step 'I click on the page'
  end
  step %(wait 1 second)
end

Given(/^I have a process "([^"]*)" as part of the "([^"]*)" instrument which requires a witness$/) do |process_name, instrument_name|
  step %(I have a process "#{process_name}" as part of the "#{instrument_name}" instrument)
  step %(a process "#{process_name}" as part of the "#{instrument_name}" instrument requires a witness)
end

When(/^(?:|I )select "([^"]*)" from AJAX dropdown "([^"]*)"(?: within "([^"]*)")?$/) do |value, field, selector|
  with_scope(selector) do
    select(value, from: field)
    step 'I click on the page'
  end
end

Given(/^the "([^"]*)" instrument has beds setup$/) do |instrument_name|
  instrument = Instrument.find_by(name: instrument_name)
  (1..12).each do |bed_number|
    instrument.beds.create!(bed_number: bed_number, name: "P#{bed_number}", barcode: bed_number)
  end
end

Given(/^a process "([^"]*)" as part of the "([^"]*)" instrument requires a witness$/) do |process_name, instrument_name|
  InstrumentProcessesInstrument.includes(:instrument, :instrument_process)
                               .find_by!(
                                 instruments: { name: instrument_name },
                                 instrument_processes: { name: process_name }
                               )
                               .update!(witness: true)
end

Given(/^a process "([^"]*)" (requires|does not require) visual check$/) do |process_name, optional|
  instrument_process = InstrumentProcess.find_by(name: process_name)
  instrument_process.update!(visual_check_required: (optional == 'requires'))
end

Then(/^I should have (\d+) plates$/) do |num|
  expect(ProcessPlate.count).to eq(num.to_i)
end

Then(/^I (should|should not) have performed visual check on the last plate$/) do |opt|
  visual_check = ProcessPlate.last.visual_check?
  expect(visual_check).to be_truthy if opt == 'should'
  expect(visual_check).to be_falsey if opt == 'should not'
end

# frozen_string_literal: true

Given(/^instrument "([^"]*)" has a bed with name "([^"]*)" barcode "([^"]*)" and number (\d+)$/) do |instrument_name, bed_name, bed_barcode, bed_number|
  instrument = Instrument.find_by!(name: instrument_name)
  bed = Bed.new(name: bed_name, barcode: bed_barcode, bed_number: bed_number)
  instrument.beds << bed
end

Given(/^the search with UUID "([^"]*)" for barcode "([^"]*)" returns the following JSON:$/) do |search_uuid, barcode, returned_json|
  FakeSequencescapeService.instance.search_result(search_uuid, barcode, returned_json)
end

Given(/^the search with UUID "([^"]*)" for barcodes "([^"]*)" returns the following JSON:$/) do |search_uuid, barcode, returned_json|
  FakeSequencescapeService.instance.search_result(search_uuid, barcode.split(',').map(&:strip).reject(&:blank?), returned_json)
end

Given(/^I can retrieve the plate with barcode "([^"]*)" and parent barcodes "([^"]*)"$/) do |child_barcode, parent_barcodes|
  parent_barcodes_list = parent_barcodes.split(',')

  parent_labware_list = parent_barcodes_list.map do |parent_barcode|
    parent_labware = Sequencescape::Api::V2::Labware.new
    allow(parent_labware).to receive(:labware_barcode).and_return({ 'machine_barcode' => parent_barcode.to_s })
    parent_labware
  end

  child_plate = Sequencescape::Api::V2::Plate.new
  allow(child_plate).to receive(:labware_barcode).and_return({ 'machine_barcode' => child_barcode.to_s })
  allow(child_plate).to receive(:parents).and_return(parent_labware_list)
  allow(Sequencescape::Api::V2::Plate).to receive(:where).with(barcode: child_barcode).and_return([child_plate])
end

Given(/^I cannot retrieve the plate with barcode "([^"]*)"$/) do |child_barcode|
  allow(Sequencescape::Api::V2::Plate).to receive(:where).with(barcode: child_barcode).and_return([])
end

Given(/^I have a process "([^"]*)" as part of the "([^"]*)" instrument with dilution plate verification$/) do |process_name, instrument_name|
  step %Q{I have a process "#{process_name}" as part of the "#{instrument_name}" instrument with bed verification type "Verification::DilutionPlate::Nx"}
end

Given(/^I have a process "([^"]*)" as part of the "([^"]*)" instrument with "([^"]*)" assay plate verification$/) do |process_name, instrument_name, bed_type|
  step %Q{I have a process "#{process_name}" as part of the "#{instrument_name}" instrument with bed verification type "Verification::AssayPlate::#{bed_type}"}
end

Given(/^I have a process "([^"]*)" as part of the "([^"]*)" instrument with sequenom plate verification$/) do |process_name, instrument_name|
  step %Q{I have a process "#{process_name}" as part of the "#{instrument_name}" instrument with bed verification type "Verification::SequenomPlate::Nx"}
end

Given(/^I have a process "([^"]*)" as part of the "([^"]*)" instrument with x2 dilution assay nx bed verification$/) do |process_name, instrument_name|
  step %Q{I have a process "#{process_name}" as part of the "#{instrument_name}" instrument with bed verification type "Verification::DilutionAssay::NxGroup"}
end

Given(/^I have a process "([^"]*)" as part of the "([^"]*)" instrument with destroy plates verification$/) do |process_name, instrument_name|
  step %Q{I have a process "#{process_name}" as part of the "#{instrument_name}" instrument with bed verification type "Verification::OutdatedLabware::Base"}
end

Given(/^I have a process "([^"]*)" as part of the "([^"]*)" instrument with bed verification type "([^"]*)"$/) do |process_name, instrument_name, bed_verification_type|
  step %Q{I have a process "#{process_name}" as part of the "#{instrument_name}" instrument}
  instrument = Instrument.find_by_name(instrument_name)
  process = InstrumentProcess.find_by_name(process_name)
  process_link = instrument.instrument_processes_instruments.select { |inst_process| inst_process.instrument_process_id == process.id }.first
  process_link.update_attributes!(bed_verification_type: bed_verification_type)
end

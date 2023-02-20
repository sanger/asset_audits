# frozen_string_literal: true

Given(
  /^instrument "([^"]*)" has a bed with name "([^"]*)" barcode "([^"]*)" and number (\d+)$/
) do |instrument_name, bed_name, bed_barcode, bed_number|
  instrument = Instrument.find_by!(name: instrument_name)
  bed = Bed.new(name: bed_name, barcode: bed_barcode, bed_number:)
  instrument.beds << bed
end

Given(
  /^the search with UUID "([^"]*)" for barcode "([^"]*)" returns the following JSON:$/
) do |search_uuid, barcode, returned_json|
  FakeSequencescapeService.instance.search_result(search_uuid, barcode, returned_json)
end

Given(
  /^the search with UUID "([^"]*)" for barcodes "([^"]*)" returns the following JSON:$/
) do |search_uuid, barcode, returned_json|
  FakeSequencescapeService.instance.search_result(
    search_uuid,
    barcode.split(",").map(&:strip).compact_blank,
    returned_json
  )
end

# Mocking Sequencescape::Api::V2::Labware.where(barcode: barcodes)
Given(
  /^I can retrieve the labware with barcodes "([^"]*)" and lifespans "([^"]*)" and ages "([^"]*)" and existence "([^"]*)"$/
) do |barcodes, lifespans, ages, existence|
  barcode_list = barcodes.split(",").map(&:strip).compact_blank
  lifespan_list =
    lifespans
      .split(",")
      .compact_blank
      .map do |lifespan|
        lifespan.strip!
        lifespan == "nil" ? nil : lifespan.to_i
      end
  age_list = ages.split(",").compact_blank.map(&:to_i)
  exists_list = existence.split(",").compact_blank.map { |e| e.strip == "true" }

  labware_list = []
  barcode_list.each_with_index do |barcode, index|
    next unless exists_list[index]

    purpose = Sequencescape::Api::V2::Purpose.new
    allow(purpose).to receive(:lifespan).and_return(lifespan_list[index])
    allow(purpose).to receive(:name).and_return("immortal")

    labware = Sequencescape::Api::V2::Labware.new
    allow(labware).to receive(:purpose).and_return(purpose)
    allow(labware).to receive(:labware_barcode).and_return({ "machine_barcode" => barcode.to_s })
    allow(labware).to receive(:created_at).and_return(Time.zone.today - age_list[index])

    labware_list << labware
  end

  allow(Sequencescape::Api::V2::Labware).to receive(:where).with(barcode: barcode_list).and_return(labware_list)
end

Given(
  /^I can retrieve the plate with barcode "([^"]*)" and parent barcodes "([^"]*)"$/
) do |child_barcode, parent_barcodes|
  parent_barcodes_list = parent_barcodes.split(",")

  parent_labware_list =
    parent_barcodes_list.map do |parent_barcode|
      parent_labware = Sequencescape::Api::V2::Labware.new
      allow(parent_labware).to receive(:labware_barcode).and_return({ "machine_barcode" => parent_barcode.to_s })
      parent_labware
    end

  child_plate = Sequencescape::Api::V2::Plate.new
  allow(child_plate).to receive(:labware_barcode).and_return({ "machine_barcode" => child_barcode.to_s })
  allow(child_plate).to receive(:parents).and_return(parent_labware_list)
  allow(Sequencescape::Api::V2::Plate).to receive(:where).with(barcode: child_barcode).and_return([child_plate])
end

Given(/^I cannot retrieve the plate with barcode "([^"]*)"$/) do |child_barcode|
  allow(Sequencescape::Api::V2::Plate).to receive(:where).with(barcode: child_barcode).and_return([])
end

Given(
  /^I have a process "([^"]*)" as part of the "([^"]*)" instrument with dilution plate verification$/
) do |process_name, instrument_name|
  step "I have a process \"#{process_name}\" as part of the \"#{instrument_name}\" instrument with bed verification type \"Verification::DilutionPlate::Nx\""
end

Given(
  /^I have a process "([^"]*)" as part of the "([^"]*)" instrument with "([^"]*)" assay plate verification$/
) do |process_name, instrument_name, bed_type|
  step "I have a process \"#{process_name}\" as part of the \"#{instrument_name}\" instrument with bed verification type \"Verification::AssayPlate::#{bed_type}\""
end

Given(
  /^I have a process "([^"]*)" as part of the "([^"]*)" instrument with sequenom plate verification$/
) do |process_name, instrument_name|
  step "I have a process \"#{process_name}\" as part of the \"#{instrument_name}\" instrument with bed verification type \"Verification::SequenomPlate::Nx\""
end

Given(
  /^I have a process "([^"]*)" as part of the "([^"]*)" instrument with x2 dilution assay nx bed verification$/
) do |process_name, instrument_name|
  step "I have a process \"#{process_name}\" as part of the \"#{instrument_name}\" instrument with bed verification type \"Verification::DilutionAssay::NxGroup\""
end

Given(
  /^I have a process "([^"]*)" as part of the "([^"]*)" instrument with destroy plates verification$/
) do |process_name, instrument_name|
  step "I have a process \"#{process_name}\" as part of the \"#{instrument_name}\" instrument with bed verification type \"Verification::OutdatedLabware::Base\""
end

Given(
  /^I have a process "([^"]*)" as part of the "([^"]*)" instrument with bed verification type "([^"]*)"$/
) do |process_name, instrument_name, bed_verification_type|
  step "I have a process \"#{process_name}\" as part of the \"#{instrument_name}\" instrument"
  InstrumentProcessesInstrument
    .includes(:instrument, :instrument_process)
    .find_by!(instruments: { name: instrument_name }, instrument_processes: { name: process_name })
    .update!(bed_verification_type:)
end

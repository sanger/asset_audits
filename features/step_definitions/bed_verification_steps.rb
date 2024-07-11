# frozen_string_literal: true

Given(
  /^instrument "([^"]*)" has a bed with name "([^"]*)" barcode "([^"]*)" and number (\d+)$/
) do |instrument_name, bed_name, bed_barcode, bed_number|
  instrument = Instrument.find_by!(name: instrument_name)
  bed = Bed.new(name: bed_name, barcode: bed_barcode, bed_number:)
  instrument.beds << bed
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

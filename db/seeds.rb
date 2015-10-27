# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


inst = Instrument.create(:name => "Beckman NX", :barcode => "1234")

inst.instrument_processes << InstrumentProcess.create(:name => "Working dilution", :key => "slf_working_dilution", :request_instrument => 1)
inst.instrument_processes << InstrumentProcess.create(:name => "Pico dilution", :key => "slf_pico_dilution", :request_instrument => 1)

# Add destroy labware Instrument
instrument = Instrument.create ({:name => "Destroying instrument", :barcode => "destroying-instrument" })
instrument_process = InstrumentProcess.create ({:name => "Destroying labware process", :key => "destroy_labware",
  :request_instrument => false })
instrument_processes_instrument = InstrumentProcessesInstrument.create ({:instrument => instrument,
  :instrument_process => instrument_process, :bed_verification_type => "Verification::OutdatedLabware::Base"})

# Adds Visual check required for some instruments
[*InstrumentProcess.find_by_name("Pico dilution")].each do |ip|
  ip.update_attributes({
  :visual_check_required => true
  })
end
[*InstrumentProcess.find_by_name("Pico assay plate creation")].each do |ip|
  ip.update_attributes({
  :visual_check_required => true
  })
end

Factory.sequence :barcode_number do |n|
  "#{n}"
end

Factory.sequence :instrument_name do |n|
  "Instrument #{n}"
end

Factory.sequence :instrument_process_name do |n|
  "Instrument Process #{n}"
end

Factory.sequence :instrument_process_key do |n|
  "instrument_process_#{n}"
end

Factory.sequence :bed_barcode do |n|
  "#{n}"
end

Factory.sequence :bed_number do |n|
  "#{n}"
end

Factory.sequence :bed_name do |n|
  "#{n}"
end

Factory.define :bed do |a|
  a.name       { |a| Factory.next :bed_name }
  a.barcode    { |a| Factory.next :bed_barcode }
  a.bed_number { |a| Factory.next :bed_number }
end

Factory.define :instrument do |a|
  a.barcode  { |a| Factory.next :barcode_number }
  a.name     { |a| Factory.next :instrument_name }

  a.after_build { |instrument| (1..16).each { |bed_number| Factory(:bed, name: "P#{bed_number}", barcode: bed_number, bed_number: bed_number, instrument_id: instrument.id) } }
end

Factory.define :instrument_process do |a|
  a.name     { |a| Factory.next :instrument_process_name }
  a.key      { |a| Factory.next :instrument_process_key }
end

Factory.define :instrument_processes_instrument do |ipi|
  ipi.instrument              { |instrument| instrument.association(:instrument) }
  ipi.instrument_process      { |instrument_process| instrument_process.association(:instrument_process) }
  ipi.bed_verification_type   'Verification::Base'
end

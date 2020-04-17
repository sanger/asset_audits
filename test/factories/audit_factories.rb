# frozen_string_literal: true
# FactoryBot.sequence :barcode_number do |n|
#   "#{n}"
# end

# FactoryBot.sequence :instrument_name do |n|
#   "Instrument #{n}"
# end

# FactoryBot.sequence :instrument_process_name do |n|
#   "Instrument Process #{n}"
# end

# FactoryBot.sequence :instrument_process_key do |n|
#   "instrument_process_#{n}"
# end

# FactoryBot.sequence :bed_barcode do |n|
#   "#{n}"
# end

# FactoryBot.sequence :bed_number do |n|
#   "#{n}"
# end

# FactoryBot.sequence :bed_name do |n|
#   "#{n}"
# end

FactoryBot.define :bed do |a|
  sequence(:name)       { |n| "#{n}" }
  sequence(:barcode)    { |n| "#{n}" }
  sequence(:bed_number) { |n| "#{n}" }
  # a.name       { |a| FactoryBot.next :bed_name }
  # a.barcode    { |a| FactoryBot.next :bed_barcode }
  # a.bed_number { |a| FactoryBot.next :bed_number }
end

FactoryBot.define :instrument do |a|
  sequence(:name)    { |n| "Instrument #{n}" }
  sequence(:barcode) { |n| "#{n}" }
  # a.barcode  { |a| FactoryBot.next :barcode_number }
  # a.name     { |a| FactoryBot.next :instrument_name }

  a.after_build { |instrument| (1..16).each { |bed_number| FactoryBot(:bed, name: "P#{bed_number}", barcode: bed_number, bed_number: bed_number, instrument_id: instrument.id) } }
end

FactoryBot.define :instrument_process do |a|
  sequence(:name) { |n| "Instrument Process #{n}" }
  sequence(:key)  { |n| "instrument_process_#{n}" }
  # a.name     { |a| FactoryBot.next :instrument_process_name }
  # a.key      { |a| FactoryBot.next :instrument_process_key }
end

FactoryBot.define :instrument_processes_instrument do |ipi|
  ipi.instrument              { |instrument| instrument.association(:instrument) }
  ipi.instrument_process      { |instrument_process| instrument_process.association(:instrument_process) }
  ipi.bed_verification_type   'Verification::Base'
end

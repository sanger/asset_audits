# frozen_string_literal: true

FactoryBot.define do
  factory :bed do
    sequence(:name)       { |n| "#{n}" }
    sequence(:barcode)    { |n| "#{n}" }
    sequence(:bed_number) { |n| "#{n}" }
  end

  factory :instrument do
    sequence(:name)    { |n| "Instrument #{n}" }
    sequence(:barcode) { |n| "#{n}" }

    after(:build) do |instrument|
      (1..16).each do |bed_number|
        FactoryBot(:bed, name: "P#{bed_number}", barcode: bed_number, bed_number: bed_number, instrument_id: instrument.id)
      end
    end
  end

  factory :instrument_process do
    sequence(:name) { |n| "Instrument Process #{n}" }
    sequence(:key)  { |n| "instrument_process_#{n}" }
  end

  factory :instrument_processes_instrument do
    instrument              { |instrument| instrument.association(:instrument) }
    instrument_process      { |instrument_process| instrument_process.association(:instrument_process) }
    bed_verification_type   { 'Verification::Base' }
  end
end

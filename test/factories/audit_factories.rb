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

    beds do
      (1..16).map do |bed_number|
        build(:bed, name: "P#{bed_number}", barcode: bed_number, bed_number: bed_number)
      end
    end
  end

  factory :instrument_process do
    sequence(:name) { |n| "Instrument Process #{n}" }
    sequence(:key)  { |n| "instrument_process_#{n}" }
  end

  factory :instrument_processes_instrument do
    association(:instrument)
    association(:instrument_process)
    bed_verification_type { 'Verification::Base' }
  end
end

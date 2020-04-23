# frozen_string_literal: true

FactoryBot.define do
  factory :v2_plate, class: Sequencescape::Api::V2::Plate do
    transient { barcode { 'default_value' } }

    labware_barcode { { 'ean13_barcode' => '', 'machine_barcode' => barcode, 'human_barcode' => '' } }

    after(:build) do |plate, _evaluator|
      plate.stubs(:parents).returns([])
    end

    factory :v2_plate_with_parent do
      transient { parent_barcode { 'default_value' } }

      after(:build) do |plate, evaluator|
        plate.stubs(:parents).returns([FactoryBot.create(:v2_labware, barcode: evaluator.parent_barcode)])
      end
    end

    skip_create
  end

  factory :v2_labware, class: Sequencescape::Api::V2::Labware do
    transient { barcode { 'default_value' } }

    labware_barcode { { 'ean13_barcode' => '', 'machine_barcode' => barcode, 'human_barcode' => '' } }

    skip_create
  end
end

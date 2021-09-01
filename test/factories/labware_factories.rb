# frozen_string_literal: true

FactoryBot.define do
  factory :v2_plate, class: Sequencescape::Api::V2::Plate do
    transient { barcode { 'default_value' } }

    size { 96 }
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

    factory :v2_plate_with_parents_and_quadrant_metadata do
      transient do
        metadata do
          {
            'Quadrant 1' => 'Empty',
            'Quadrant 2' => 'Empty',
            'Quadrant 3' => 'Empty',
            'Quadrant 4' => 'Empty'
          }
        end
      end

      after(:build) do |plate, evaluator|
        parents = []
        evaluator.metadata.each_value do |parent_barcode|
          next if parent_barcode == 'Empty'

          parents << FactoryBot.create(:v2_labware, barcode: parent_barcode)
        end
        plate.stubs(:parents).returns(parents)
        plate.stubs(:custom_metadatum_collection).returns(FactoryBot.create(:custom_metadatum_collection,
                                                                            metadata: evaluator.metadata))
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

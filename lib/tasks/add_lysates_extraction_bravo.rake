# frozen_string_literal: true

namespace :lysates_extraction_bravo do
  SRC_BEDS = %w[580000004838].freeze
  DEST_BEDS = %w[580000014851].freeze
  SRC_BED_NUMS = %w[4].freeze
  DEST_BED_NUMS = %w[14].freeze

  task add: :environment do
    ActiveRecord::Base.transaction do
      # create robot instrument and the lysates process
      instrument_bravo = Instrument.find_or_create_by!(name: 'Bravo', barcode: '4880000059873')
      instrument_process = InstrumentProcess.find_or_create_by!(name: 'Lysates Extraction', key: 'lysates_extraction')
      InstrumentProcessesInstrument.find_or_create_by!(
        instrument: instrument_bravo,
        instrument_process: instrument_process,
        bed_verification_type: 'Verification::DilutionPlate::BravoLE'
      )

      # create robot beds
      SRC_BEDS.each_with_index.map do |bc, index|
        Bed.find_or_create_by!({ name: "SCRC#{SRC_BED_NUMS[index]}",
                                 bed_number: SRC_BED_NUMS[index],
                                 barcode: bc,
                                 instrument: instrument_bravo })
      end
      DEST_BEDS.each_with_index.map do |bc, index|
        Bed.find_or_create_by!({ name: "DEST#{DEST_BED_NUMS[index]}",
                                 bed_number: DEST_BED_NUMS[index],
                                 barcode: bc,
                                 instrument: instrument_bravo })
      end
    end
  end

  task remove: :environment do
    ActiveRecord::Base.transaction do
      instrument_bravo = Instrument.find_by(name: 'Bravo', barcode: '4880000059873')
      instrument_process = InstrumentProcess.find_by(name: 'Lysates Extraction', key: 'lysates_extraction')
      instrument_processes_instrument = InstrumentProcessesInstrument.find_by(
        instrument: instrument_bravo,
        instrument_process: instrument_process,
        bed_verification_type: 'Verification::DilutionPlate::BravoLE'
      )
      instrument_processes_instruments.each(&:destroy!)
      instrument_process.destroy!
    end
  end
end
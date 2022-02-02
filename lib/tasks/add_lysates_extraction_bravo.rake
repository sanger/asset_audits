# frozen_string_literal: true

SRC_BEDS_LE_BRV = %w[580000004838].freeze
DEST_BEDS_LE_BRV = %w[580000014851].freeze
SRC_BED_NUMS_LE_BRV = %w[4].freeze
DEST_BED_NUMS_LE_BRV = %w[14].freeze

namespace :lysates_extraction_bravo do
  task add: :environment do # rubocop:todo Rake/Desc
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
      SRC_BEDS_LE_BRV.each_with_index.map do |bc, index|
        Bed.find_or_create_by!(
          {
            name: "P#{SRC_BED_NUMS_LE_BRV[index]}",
            bed_number: SRC_BED_NUMS_LE_BRV[index],
            barcode: bc,
            instrument: instrument_bravo
          }
        )
      end
      DEST_BEDS_LE_BRV.each_with_index.map do |bc, index|
        Bed.find_or_create_by!(
          {
            name: "P#{DEST_BED_NUMS_LE_BRV[index]}",
            bed_number: DEST_BED_NUMS_LE_BRV[index],
            barcode: bc,
            instrument: instrument_bravo
          }
        )
      end
    end
  end

  task remove: :environment do # rubocop:todo Rake/Desc
    ActiveRecord::Base.transaction do
      # Leave the robot and process, but remove the join table entry so it no
      # longer shows the process for that instrument (as the robot and / or process may be used elsewhere)
      instrument_bravo = Instrument.find_by(name: 'Bravo', barcode: '4880000059873')
      instrument_process = InstrumentProcess.find_by(name: 'Lysates Extraction', key: 'lysates_extraction')
      instrument_processes_instrument =
        InstrumentProcessesInstrument.find_by(
          instrument: instrument_bravo,
          instrument_process: instrument_process,
          bed_verification_type: 'Verification::DilutionPlate::BravoLE'
        )
      instrument_processes_instrument.destroy!
    end
  end
end

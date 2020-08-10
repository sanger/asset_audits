# frozen_string_literal: true

namespace :lysates_extraction_hamilton do
  SRC_BEDS_LE_HAM = %w[580000004838 580000005699].freeze
  DEST_BEDS_LE_HAM = %w[580000034668 580000035672].freeze
  SRC_BED_NUMS_LE_HAM = %w[4 5].freeze
  DEST_BED_NUMS_LE_HAM = %w[34 35].freeze

  task add: :environment do
    ActiveRecord::Base.transaction do
      # create robot instrument and the lysates process
      instrument_hamilton = Instrument.find_or_create_by!(name: 'Hamilton Star 6', barcode: '4880000067878')
      instrument_process = InstrumentProcess.find_or_create_by!(name: 'Lysates Extraction', key: 'lysates_extraction')
      InstrumentProcessesInstrument.find_or_create_by!(
        instrument: instrument_hamilton,
        instrument_process: instrument_process,
        bed_verification_type: 'Verification::DilutionPlate::Hamilton'
      )

      # create robot beds
      SRC_BEDS_LE_HAM.each_with_index.map do |bc, index|
        Bed.find_or_create_by!({ name: "SCRC#{SRC_BED_NUMS_LE_HAM[index]}",
                                 bed_number: SRC_BED_NUMS_LE_HAM[index],
                                 barcode: bc,
                                 instrument: instrument_hamilton })
      end
      DEST_BEDS_LE_HAM.each_with_index.map do |bc, index|
        Bed.find_or_create_by!({ name: "DEST#{DEST_BED_NUMS_LE_HAM[index]}",
                                 bed_number: DEST_BED_NUMS_LE_HAM[index],
                                 barcode: bc,
                                 instrument: instrument_hamilton })
      end
    end
  end

  task remove: :environment do
    ActiveRecord::Base.transaction do
      # Leave the robot and process, but remove the join table entry so it no longer shows the process for that instrument
      # (as the robot and / or process may be used elsewhere)
      instrument_hamilton = Instrument.find_by(name: 'Hamilton Star 6', barcode: '4880000067878')
      instrument_process = InstrumentProcess.find_by(name: 'Lysates Extraction', key: 'lysates_extraction')
      instrument_processes_instrument = InstrumentProcessesInstrument.find_by(
        instrument: instrument_hamilton,
        instrument_process: instrument_process,
        bed_verification_type: 'Verification::DilutionPlate::Hamilton'
      )
      instrument_processes_instrument.destroy!
    end
  end
end

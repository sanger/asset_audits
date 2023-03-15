# frozen_string_literal: true

class AddBiorobot < ActiveRecord::Migration
  ROBOT_BARCODE = "4880001006869"
  BEDS = %w[4880001007873 580000015865 4880001008658 4880001009662 4880001010828].freeze

  def self.up
    ActiveRecord::Base.transaction do
      instrument = Instrument.create!(name: "Biorobot", barcode: ROBOT_BARCODE)
      instrument_process = InstrumentProcess.create!(name: "Biorobot", key: "biorobot", request_instrument: true)
      InstrumentProcessesInstrument.create!(
        instrument:,
        instrument_process:,
        bed_verification_type: "Verification::DilutionPlate::Biorobot"
      )
      BEDS.each_with_index.map do |b, pos|
        Bed.create!({ name: "P#{pos + 1}", bed_number: pos + 1, barcode: b, instrument: })
      end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      BEDS.each { |b| Bed.find_by(barcode: b).destroy }
      InstrumentProcess.find_by(name: "Biorobot").destroy
      Instrument.find_by(name: "Biorobot").destroy
    end
  end
end

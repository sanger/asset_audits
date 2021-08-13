# frozen_string_literal: true

class InstrumentProcessesInstrument < ApplicationRecord
  belongs_to :instrument
  belongs_to :instrument_process

  validates_presence_of :instrument
  validates_presence_of :instrument_process

  validates_uniqueness_of :instrument_id, scope: [:instrument_process_id]

  before_save :default_bed_verification_type

  def default_bed_verification_type
    self.bed_verification_type = 'Verification::Base' if bed_verification_type.nil?
  end

  def self.get_bed_verification_type(instrument_barcode, instrument_process_id)
    instrument_processes_instrument = find_from_instrument_barcode_and_instrument_process_id(instrument_barcode, instrument_process_id)
    return nil if instrument_processes_instrument.nil?
    return nil if instrument_processes_instrument.bed_verification_type.nil?

    eval(instrument_processes_instrument.bed_verification_type)
  end

  def self.find_partial_name!(instrument_barcode, instrument_process_id)
    get_bed_verification_type(instrument_barcode, instrument_process_id).try(:partial_name)
  end

  def self.find_from_instrument_barcode_and_instrument_process_id(instrument_barcode, instrument_process_id)
    instrument = Instrument.find_by_barcode(instrument_barcode)
    process = InstrumentProcess.find_by_id(instrument_process_id)
    return nil if instrument.nil? || process.nil?

    find_by_instrument_id_and_instrument_process_id(instrument.id, process.id)
  end
end

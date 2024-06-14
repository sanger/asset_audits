# frozen_string_literal: true

class InstrumentProcessesInstrument < ApplicationRecord
  belongs_to :instrument
  belongs_to :instrument_process

  # rubocop:todo Rails/UniqueValidationWithoutIndex
  validates :instrument_id, uniqueness: { scope: [:instrument_process_id] }

  # rubocop:enable Rails/UniqueValidationWithoutIndex

  before_save :default_bed_verification_type

  def default_bed_verification_type
    self.bed_verification_type = "Verification::Base" if bed_verification_type.nil?
  end

  def self.get_bed_verification_type(instrument_barcode, instrument_process_id)
    instrument_processes_instrument =
      find_from_instrument_barcode_and_instrument_process_id(instrument_barcode, instrument_process_id)
     return nil if instrument_processes_instrument.nil?
    return nil if instrument_processes_instrument.bed_verification_type.nil?

    eval(instrument_processes_instrument.bed_verification_type) # rubocop:todo Security/Eval
  end

  def self.find_partial_name!(instrument_barcode, instrument_process_id)
    get_bed_verification_type(instrument_barcode, instrument_process_id).try(:partial_name)
  end

  def self.find_from_instrument_barcode_and_instrument_process_id(instrument_barcode, instrument_process_id)
    instrument = Instrument.find_by(barcode: instrument_barcode)
    process = InstrumentProcess.find_by(id: instrument_process_id)

    # Selecting 'Destroying labware' in 'Instrument Process' dropdown shows help
    # text. This needs an instrument barcode. But to show the help text without
    # a barcode, we use a feature of the processes. If a process doesn't need a
    # specific instrument (i.e., require_instrument is false), we use the first
    # instrument of the process. This enables help text display but doesn't
    # affect the verification process, which still needs the instrument barcode.
    instrument ||= process&.instruments&.first unless process&.request_instrument

    return nil if instrument.nil? || process.nil?

    find_by(instrument_id: instrument.id, instrument_process_id: process.id)
  end
end

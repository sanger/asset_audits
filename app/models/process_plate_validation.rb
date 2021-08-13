# frozen_string_literal: true
module ProcessPlateValidation
  def self.included(base)
    base.class_eval do
      validate :user_login_exists
      validate :instrument_exists
      validate :process_on_instrument, if: :instrument?
      validate :witness_for_process, if: :witness_required?
      validate :visual_check_performed, if: :visual_check_required?
    end
  end

  def user_login_exists
    errors.add(:user_barcode, 'Invalid user') if user_login.nil?
  end

  def instrument_exists
    errors.add(:instrument, 'Invalid instrument barcode') if instrument.nil?
  end

  def process_on_instrument
    errors.add(:instrument_process, 'Invalid process for instrument') unless instrument.instrument_processes.include?(instrument_process)
  end

  def witness_for_process
    errors.add(:witness_barcode, 'Invalid witness barcode') if witness_login.blank? || witness_login == user_login
  end

  def visual_check_performed
    errors.add(:visual_check, 'Visual check required for this type') unless visual_check
  end

  def witness_required?
    return false unless instrument

    instrument.instrument_processes_instruments
              .where(instrument_process_id: instrument_process, witness: true)
              .exists?
  end

  def visual_check_required?
    return instrument_process.visual_check_required? unless instrument_process.nil?
  end

  def instrument?
    return true if instrument

    false
  end
end

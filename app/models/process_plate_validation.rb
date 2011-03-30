module  ProcessPlateValidation
  def self.included(base)
    base.class_eval do
      validate :user_login_exists
      validate :instrument_exists
      validate :process_on_instrument, :if => :instrument?
      validate :witness_for_process, :if => :witness_required?
    end
  end

  def user_login_exists
    errors.add(:user_barcode, "Invalid user") if user_login.nil?
  end
  
  def instrument_exists
    errors.add(:instrument, "Invalid instrument barcode") if instrument.nil?
  end
  
  def process_on_instrument
    errors.add(:instrument_process, "Invalid process for instrument") unless instrument.instrument_processes.include?(instrument_process)
  end
  
  def witness_for_process
    errors.add(:witness_barcode, "Invalid witness barcode") if witness_login.blank?  || witness_login == user_login
  end
  
  
  def witness_required?
    return false unless instrument
    instrument_processes_instrument = instrument.instrument_processes_instruments.select{ |instrument_process_link| instrument_process_link.instrument_process_id == instrument_process.id }
    (! instrument_processes_instrument.empty? ) && instrument_processes_instrument.first.witness
  end
  
  def instrument?
    return true if instrument
    false
  end
  
end
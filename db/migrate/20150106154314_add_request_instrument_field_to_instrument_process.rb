class AddRequestInstrumentFieldToInstrumentProcess < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
       add_column :instrument_processes, :request_instrument, :boolean, default: true
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      remove_column :instrument_processes, :request_instrument
    end
  end
end

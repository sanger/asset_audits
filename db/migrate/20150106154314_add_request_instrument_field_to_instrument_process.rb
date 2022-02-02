# frozen_string_literal: true

class AddRequestInstrumentFieldToInstrumentProcess < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction { add_column :instrument_processes, :request_instrument, :boolean, default: true }
  end

  def self.down
    ActiveRecord::Base.transaction { remove_column :instrument_processes, :request_instrument }
  end
end

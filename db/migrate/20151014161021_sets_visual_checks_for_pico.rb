# frozen_string_literal: true

class SetsVisualChecksForPico < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      [*InstrumentProcess.find_by(key: "slf_pico_dilution")].each { |ip| ip.update({ visual_check_required: true }) }
      [*InstrumentProcess.find_by(key: "slf_pico_assay_plates")].each do |ip|
        ip.update({ visual_check_required: true })
      end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      # No down implementation
    end
  end
end

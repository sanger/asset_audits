class SetsVisualChecksForPico < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      [*InstrumentProcess.find_by_name("Pico dilution")].each do |ip|
        ip.update_attributes({
        :visual_check_required => true
      })
      end
      [*InstrumentProcess.find_by_name("Pico assay plate creation")].each do |ip|
        ip.update_attributes({
        :visual_check_required => true
      })
      end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
    end
  end
end

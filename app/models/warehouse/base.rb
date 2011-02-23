module Warehouse::Base
  def self.included(base)
    config = YAML.load(ERB.new(File.read(File.dirname(__FILE__) + "/../../../config/database.yml")).result)
    base.send(:establish_connection, config["#{Rails.env}_warehouse_two"])
    base.class_eval do
      set_primary_key :dont_use_id
      alias_attribute :id, :dont_use_id
      default_scope :conditions => { :is_current => true }
    end
  end

end

class Verification::Base
  include ActiveModel::Validations

  attr_accessor :instrument_barcode
  attr_accessor :scanned_values
  attr_accessor :api

  class_inheritable_accessor :source_beds
  class_inheritable_accessor :destination_beds


  def scanned_values
    @attributes[:scanned_values]
  end

  def api
    @attributes[:api]
  end

  def instrument
    Instrument.find_by_barcode(@attributes[:instrument_barcode])
  end

  def initialize(attributes = {})
    @attributes = attributes
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end

  def validate(record)
    record.errors.add_on_blank(attributes, options[:message])
  end

  def self.all_types_for_select
    ["Verification::Base", "Verification::DilutionPlate::Nx", "Verification::DilutionPlate::Fx", "Verification::AssayPlate::Nx", "Verification::AssayPlate::Fx"]
  end

  def self.partial_name
    "default"
  end

  def validate_and_create_audits?(params)
    process_plate = ProcessPlate.new({
      :api => api,
      :user_barcode => params[:user_barcode],
      :instrument_barcode => params[:instrument_barcode],
      :source_plates => params[:source_plates],
      :visual_check => params[:visual_check]=="1",
      :instrument_process_id => params[:instrument_process],
      :witness_barcode => params[:witness_barcode]
      })
    if process_plate.save
      process_plate.create_audits
      process_plate.post_audit_actions!
    else
      # add errors to the base of this object
      save_errors_to_base(process_plate.errors)
      return false
    end

    true
  end

  def save_errors_to_base(object_errors)
    object_errors.each do |key, message|
      self.errors.add(key, message)
    end
  end

end


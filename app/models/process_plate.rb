# frozen_string_literal: true
class ProcessPlate < ActiveRecord::Base
  include ProcessPlateValidation
  attr_accessor :api
  attr_accessor :user_name
  attr_accessor :witness_name
  attr_accessor :instrument_used
  attr_accessor :asset_search_results
  # remove active record

  belongs_to :instrument_process

  # after_create :create_events

  def user_login
    return user_name unless user_name.blank?
    self.user_name = User.login_from_user_code(user_barcode)
  end

  def witness_login
    return nil if witness_barcode.blank?
    return witness_name unless witness_name.blank?
    self.witness_name = User.login_from_user_code(witness_barcode)
  end

  def barcodes
    source_plates.scan(/\w+/).map { |plate| plate }
  end

  def instrument
    return instrument_used unless instrument_used.blank?
    self.instrument_used = Instrument.find_by_barcode(instrument_barcode)
  end

  def search_resource
    api.search.find(Settings.search_find_assets_by_barcode)
  end

  def asset_uuids_from_plate_barcodes
    asset_search_results_from_plate_barcodes.map(&:uuid)
  end

  def asset_search_results_from_plate_barcodes
    return asset_search_results unless asset_search_results.blank?
    self.asset_search_results = search_resource.all(api.plate, barcode: barcodes)
  end

  def api
    @api ||= Sequencescape::Api.new(url: Settings.sequencescape_api_v1, authorisation: Settings.sequencescape_authorisation)
  end

  def create_audits
    asset_uuids_from_plate_barcodes.each do |asset_uuid|
      create_remote_audit(asset_uuid)
    end
  end
  handle_asynchronously :create_audits

  def create_remote_audit(asset_uuid)
    api.asset_audit.create!(
      key: instrument_process.key,
      message: "Process '#{instrument_process.name}' performed on instrument #{instrument.name}",
      created_by: user_login,
      asset: asset_uuid,
      witnessed_by: witness_login
    )
  end

  def post_audit_actions!
    subtract_volumes if defined?(:subtract_volumes)
  end

  # This update is not really in the right application
  include PostAuditActions::SubtractionVolumeForWorkingDilution
end

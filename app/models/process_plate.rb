# frozen_string_literal: true

class ProcessPlate < ApplicationRecord
  include ProcessPlateValidation

  BARCODE_REGEX = /\S+/.freeze
  RECEIVE_PLATES_MAX = 15

  # @return [Sequencescape::Client::Api] An API object for interacting with the V1 API
  attr_writer :api

  belongs_to :instrument_process

  def user_login
    @user_login ||= User.login_from_user_code(user_barcode)
  end

  def witness_login
    @witness_login ||= User.login_from_user_code(witness_barcode) unless witness_barcode.blank?
  end

  def barcodes
    source_plates.scan(BARCODE_REGEX)
  end

  def instrument
    @instrument ||= Instrument.find_by_barcode(instrument_barcode)
  end

  def search_resource
    api.search.find(Settings.search_find_assets_by_barcode)
  end

  def asset_uuids_from_plate_barcodes
    asset_search_results_from_plate_barcodes.map(&:uuid)
  end

  def asset_search_results_from_plate_barcodes
    @asset_search_results_from_plate_barcodes ||= search_resource.all(api.plate, barcode: barcodes)
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
      witnessed_by: witness_login,
      metadata: metadata
    )
  end

  def post_audit_actions!
    subtract_volumes if defined?(:subtract_volumes)
  end

  def num_unique_barcodes
    barcodes.uniq.length
  end

  # This update is not really in the right application
  include PostAuditActions::SubtractionVolumeForWorkingDilution
end

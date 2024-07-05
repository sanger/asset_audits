# frozen_string_literal: true

class ProcessPlate < ApplicationRecord
  include ProcessPlateValidation

  BARCODE_REGEX = /\S+/
  RECEIVE_PLATES_MAX = 15

  belongs_to :instrument_process

  def user_login
    @user_login ||= User.login_from_user_code(user_barcode)
  end

  def witness_login
    @witness_login ||= User.login_from_user_code(witness_barcode) if witness_barcode.present?
  end

  def barcodes
    source_plates.scan(BARCODE_REGEX)
  end

  def instrument
    @instrument ||= Instrument.find_by(barcode: instrument_barcode)
  end

  def asset_uuids_from_plate_barcodes
    Sequencescape::Api::V2::Plate.where(barcode: barcodes).map(&:uuid)
  end

  def create_audits
    asset_uuids_from_plate_barcodes.each { |asset_uuid| create_remote_audit(asset_uuid) }
  end
  handle_asynchronously :create_audits

  def create_remote_audit(asset_uuid)
    options = {
      key: instrument_process.key,
      message: "Process '#{instrument_process.name}' performed on instrument #{instrument.name}",
      created_by: user_login,
      asset_uuid:,
      witnessed_by: witness_login,
      metadata:
    }
    Sequencescape::Api::V2::AssetAudit.create!(options)
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

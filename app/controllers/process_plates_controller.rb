# frozen_string_literal: true

class ProcessPlatesController < ApplicationController
  skip_before_action :configure_api, except: [:create]

  attr_accessor :messages

  def index; end

  def new
    @processes_requiring_visual_check = InstrumentProcess.where(visual_check_required: true).pluck(:id)
    @process_plate = ProcessPlate.new
  end

  def create # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    bed_verification_model =
      InstrumentProcessesInstrument.get_bed_verification_type(params[:instrument_barcode], params[:instrument_process])
    raise 'Invalid instrument or process' if bed_verification_model.nil?

    bed_layout_verification =
      bed_verification_model.new(
        instrument_barcode: params[:instrument_barcode],
        scanned_values: params[:robot],
        api: api
      )
    raise format_errors(bed_layout_verification) unless bed_layout_verification.validate_and_create_audits?(params)

    unless receive_plates_process?(params)
      back_to_new_with_message('Success')
      return
    end

    # here on is relevant to 'receiving plates' only
    # the param is called 'source_plates' but we could be working with tube racks or plates etc.
    barcodes = sanitize_barcodes(params[:source_plates])
    raise 'No barcodes were provided' if barcodes.empty?

    flash[:notice] = "Scanned #{bed_layout_verification.process_plate&.num_unique_barcodes} barcodes."
    redirect_to(new_process_plate_path)
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to(new_process_plate_path)
  end

  def format_errors(obj)
    obj.errors.values.flatten.join("\n")
  end

  def back_to_new_with_message(message, flash_type = :notice)
    flash[flash_type] = message
    redirect_to(new_process_plate_path)
  end

  # find out if the 'receive_plates' process was executed
  def receive_plates_process?(params)
    @receive_plates_process ||=
      InstrumentProcess.find_by(id: params[:instrument_process]).key.eql?('slf_receive_plates')
  end

  # Returns a list of unique barcodes by removing blanks and duplicates
  def sanitize_barcodes(barcodes)
    barcodes.split(/\s+/).reject(&:blank?).compact.uniq
  end

  def all_labware_created?(results)
    return false if results.any? { |_barcode, details| details[:success] == 'No' }

    true
  end
end

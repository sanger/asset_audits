# frozen_string_literal: true
class ProcessPlatesController < ApplicationController
  require 'wrangler'

  skip_before_filter :configure_api, except: [:create]

  attr_accessor :messages

  def index
  end

  def new
    @processes_requiring_visual_check = InstrumentProcess.where(visual_check_required: true).pluck(:id)
    @process_plate = ProcessPlate.new
  end

  def create
    respond_to do |format|
      bed_verification_model = InstrumentProcessesInstrument.get_bed_verification_type(params[:instrument_barcode], params[:instrument_process])
      if bed_verification_model.nil?
        flash[:error] = 'Invalid instrument or process'
      else
        bed_layout_verification = bed_verification_model.new(
          instrument_barcode: params[:instrument_barcode],
          scanned_values: params[:robot],
          api: api
        )
        if bed_layout_verification.validate_and_create_audits?(params)
          # if the instrument process is "Receive plates", call the 'wrangler/tube_rack' API
          # the param is called 'source_plates' but we could be working with tube racks or plates etc.
          barcodes = sanitize_barcodes(params[:source_plates])
          receive_plates_process = InstrumentProcess.find_by(id: params[:instrument_process]).key.eql?('slf_receive_plates')

          if barcodes && receive_plates_process
            Wrangler.call_api(barcodes)
            Lighthouse.call_api(barcodes)
          end

          # add a flash on the page for the number of unique barcodes scanned in
          num_unique_barcodes = bed_layout_verification.process_plate&.barcodes.uniq.length
          if num_unique_barcodes
            flash[:notice] = "Success - #{num_unique_barcodes} unique plate(s) scanned"
          else
            flash[:notice] = "Success"
          end
        else
          flash[:error] = bed_layout_verification.errors.values.flatten.join("\n")
        end
      end
      format.html { redirect_to(new_process_plate_path) }
    end
  end

  private

  def sanitize_barcodes(barcodes)
    sanitized_barcodes = [barcodes].map do |s|
      s.split(/\s/).reject(&:blank?)
    end
    sanitized_barcodes.flatten.uniq
  end
end

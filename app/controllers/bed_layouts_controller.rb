# frozen_string_literal: true

class BedLayoutsController < ApplicationController
  skip_before_action :configure_api

  def bed_layout_partial # rubocop:disable Metrics/MethodLength
    bed_layout_partial_name =
      InstrumentProcessesInstrument.find_partial_name!(params[:instrument_barcode], params[:instrument_process_id])
    @bed_verification_model =
      InstrumentProcessesInstrument.get_bed_verification_type(
        params[:instrument_barcode],
        params[:instrument_process_id]
      )

    bed_layout_partial_name = Verification::Base.partial_name if bed_layout_partial_name.blank?

    respond_to do |format|
      format.html do
        render partial: "bed_layouts/#{bed_layout_partial_name}", layout: false, locals: { barcodes: "", location: "" }
      end
    end
  end

  def pre_validate_layout # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    bed_layout_partial_name =
      InstrumentProcessesInstrument.find_partial_name!(params[:instrument_barcode], params[:instrument_process_id])

    bed_verification_model =
      InstrumentProcessesInstrument.get_bed_verification_type(
        params[:instrument_barcode],
        params[:instrument_process_id]
      )
    raise "Invalid instrument or process" if bed_verification_model.nil?

    bed_layout_verification =
      bed_verification_model.new(
        instrument_barcode: params[:instrument_barcode],
        scanned_values: params[:scanned_values],
        api:
      )

    barcodes = bed_layout_verification.pre_validate
    if barcodes
      flash.now[:error] = nil
    else
      begin
        raise format_errors(bed_layout_verification)
      rescue StandardError => e
        flash[:error] = e.message
      end
    end

    respond_to do |format|
      format.html do
        render partial: "bed_layouts/#{bed_layout_partial_name}",
               layout: false,
               locals: {
                 barcodes: barcodes ? barcodes.join("\n") : "",
                 location: params[:scanned_values]
               }
      end
    end
  end
end

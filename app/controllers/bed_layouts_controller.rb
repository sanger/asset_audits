# frozen_string_literal: true

class BedLayoutsController < ApplicationController
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

  # This method is used to handle pre-validation before the user presses the submit button.
  # Currently, it is called when the location is entered (destroy_location.html.haml).
  # If the location barcode validation succeeds, it renders the bed_layout_partial with
  # all labware within the location.
  # If the location barcode validation fails, it renders the bed_layout_partial with an error message.
  # The location barcode to be pre-validated needs to be passed as a param called 'scanned_values'.
  def pre_validate_layout # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    bed_layout_partial_name =
      InstrumentProcessesInstrument.find_partial_name!(params[:instrument_barcode], params[:instrument_process_id])

    bed_verification_model =
      InstrumentProcessesInstrument.get_bed_verification_type(
        params[:instrument_barcode],
        params[:instrument_process_id]
      )
    raise "Invalid instrument or process" if bed_verification_model.nil?

    # Param scanned_values tis used to pass the field to be validated
    bed_layout_verification =
      bed_verification_model.new(
        instrument_barcode: params[:instrument_barcode],
        scanned_values: params[:scanned_values]
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

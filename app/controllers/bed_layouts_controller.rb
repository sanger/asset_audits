# frozen_string_literal: true

class BedLayoutsController < ApplicationController
  skip_before_action :configure_api

  def bed_layout_partial
    bed_layout_partial_name = InstrumentProcessesInstrument.find_partial_name!(params[:instrument_barcode], params[:instrument_process_id])
    @bed_verification_model = InstrumentProcessesInstrument.get_bed_verification_type(params[:instrument_barcode], params[:instrument_process_id])

    if bed_layout_partial_name.blank?
      bed_layout_partial_name = Verification::Base.partial_name
    end

    respond_to do |format|
      format.html { render partial: "bed_layouts/#{bed_layout_partial_name}", layout: false }
    end
  end
end

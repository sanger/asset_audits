# frozen_string_literal: true

class InstrumentsController < ApplicationController
  def search
    instrument = Instrument.find_by(barcode: params[:instrument_barcode])
    render plain: instrument.nil? ? "" : instrument.name
  end

  def processes
    respond_to do |format|
      @processes = Instrument.processes_from_instrument_barcode(params[:instrument_barcode])
      format.html { render :processes, layout: false }
    end
  end

  def witness
    witness_required =
      ProcessPlate.new(
        instrument_barcode: params[:instrument_barcode],
        instrument_process_id: params[:instrument_process_id].to_i
      ).witness_required?

    render plain: witness_required ? "witness_required" : "not_required"
  end
end

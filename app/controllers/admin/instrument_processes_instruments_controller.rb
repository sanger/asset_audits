# frozen_string_literal: true

class Admin::InstrumentProcessesInstrumentsController < ApplicationController
  def create
    instrument_process_link = InstrumentProcessesInstrument.new(permitted_params)
    respond_to do |format|
      if instrument_process_link.save
        flash[:notice] = "Process added to instrument"
      else
        flash[:error] = "Process already exists for instrument"
      end
      format.html { redirect_to(admin_instrument_path(instrument_process_link.instrument)) }
    end
  end

  def destroy
    instrument_process_link = InstrumentProcessesInstrument.find(params[:id])
    instrument = instrument_process_link.instrument
    instrument_process_link.destroy
    respond_to do |format|
      flash[:notice] = "Removed process from instrument"
      format.html { redirect_to(admin_instrument_path(instrument)) }
    end
  end

  private

  def permitted_params
    params.expect(
      instrument_processes_instrument: %i[instrument_process_id instrument_id witness bed_verification_type]
    )
  end
end

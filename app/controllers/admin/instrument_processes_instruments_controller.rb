class Admin::InstrumentProcessesInstrumentsController < ApplicationController
  def create
    instrument_process_link = InstrumentProcessesInstrument.new(params[:instrument_processes_instrument])
    respond_to do |format|
      if instrument_process_link.save
        flash[:notice] = 'Process added to instrument'
      else 
        flash[:error] = 'Process already exists for instrument'
      end
      format.html { redirect_to(admin_instrument_path(instrument_process_link.instrument)  ) }
    end

  end
  
  def destroy
    instrument_process_link = InstrumentProcessesInstrument.find(params[:id])
    instrument = instrument_process_link.instrument
    instrument_process_link.destroy
    respond_to do |format|
      flash[:notice] = 'Removed process from instrument'
      format.html { redirect_to(admin_instrument_path(instrument)) }
    end
  end

end


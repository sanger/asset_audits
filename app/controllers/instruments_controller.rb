class InstrumentsController < ApplicationController
   def search
     instrument = Instrument.find_by_barcode(params[:instrument_barcode])
     render :text =>  instrument.nil? ? '' : instrument.name
   end
   
   def processes
     respond_to do |format|
       @processes = Instrument.processes_from_instrument_barcode(params[:instrument_barcode])
       format.html { render :processes , :layout => false  }
     end
   end
    
end


class InstrumentsController < ApplicationController
   def search
     instrument = Instrument.find_by_barcode(params[:instrument_barcode])
     render :text =>  instrument.nil? ? '' : instrument.name
   end
    
end


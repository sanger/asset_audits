class ProcessPlatesController < ApplicationController
  skip_before_filter :configure_api, :except => [:create]
  
  def index
  end

  def new
    @process_plate = ProcessPlate.new
  end

  def create
    
    process_plate = ProcessPlate.new({
      :api => api,
      :user_barcode => params[:user_barcode], 
      :instrument_barcode => params[:instrument_barcode], 
      :source_plates => params[:source_plates],
      :instrument_process_id => params[:instrument_process],
      :witness_barcode => params[:witness_barcode]
      })
    respond_to do |format|
       if process_plate.save
         process_plate.create_audits
         flash[:notice] = 'Added process'
         format.html { redirect_to(new_process_plate_path) }
       else 
         flash[:error] = process_plate.errors.values.flatten.first
         format.html { redirect_to(new_process_plate_path) }
       end
     end    
  end
    
end


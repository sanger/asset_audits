class ProcessPlatesController < ApplicationController
  
  def index
  end

  def new
    @process_plate = ProcessPlate.new
  end

  def create
    process_plate = ProcessPlate.new(params[:process_plate])
    respond_to do |format|
       if process_plate.save
         process_plate.create_audits(api)
         flash[:notice] = 'Added process'
         format.html { redirect_to(new_process_plate_path) }
       else 
         flash[:error] = process_plate.errors.values.flatten.first
         format.html { redirect_to(new_process_plate_path) }
       end
     end    
  end
    
end


class Admin::ProcessesController < ApplicationController
  def index
    @processes = InstrumentProcess.all
  end
  
  def new
    @process = InstrumentProcess.new
  end
  
  def edit
    @process = InstrumentProcess.find(params[:id])
  end
  
  def create
    process = InstrumentProcess.new(params[:instrument_process])
    
    respond_to do |format|
      if process.save
        flash[:notice] = 'Created process'
        format.html { redirect_to(admin_processes_path  ) }
      else 
        flash[:error] = 'Invalid inputs'
        format.html { redirect_to(new_admin_process_path) }
      end
    end
  end
  
  def update
    process = InstrumentProcess.find(params[:id])
    
    respond_to do |format|
      if process.update_attributes(params[:instrument_process])
        flash[:notice] = 'Updated process'
        format.html { redirect_to(admin_processes_path  ) }
      else 
        flash[:error] = 'Invalid inputs'
        format.html { redirect_to(new_admin_process_path) }
      end
    end
  end
  
  def destroy
    process = InstrumentProcess.find(params[:id])
    process.destroy
    # also remove links 
    
    respond_to do |format|
      flash[:notice] = 'Deleted process'
      format.html { redirect_to(admin_processes_path) }
    end
    
  end
  
  def show 
  end
  
end
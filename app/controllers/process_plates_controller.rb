class ProcessPlatesController < ApplicationController
  skip_before_filter :configure_api, :except => [:create]
  
  def index
  end

  def new
    @process_plate = ProcessPlate.new
  end

  def create
    respond_to do |format|
      bed_verification_model = InstrumentProcessesInstrument.get_bed_verification_type(params[:instrument_barcode],params[:instrument_process])
      if bed_verification_model.nil?
        flash[:error] = "Invalid instrument or process"
        format.html { redirect_to(new_process_plate_path) }
      else
        bed_layout_verification = bed_verification_model.new(:instrument_barcode => params[:instrument_barcode], :scanned_values => params[:robot], :api => api)
        if bed_layout_verification.validate_and_create_audits?(params)
          flash[:notice] = 'Success'
          format.html { redirect_to(new_process_plate_path) }
        else
          flash[:error] = bed_layout_verification.errors.values.flatten.first
          format.html { redirect_to(new_process_plate_path) }
        end
      end  
    end  
  end
    
end


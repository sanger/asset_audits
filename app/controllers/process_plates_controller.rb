class ProcessPlatesController < ApplicationController
  skip_before_filter :configure_api, :except => [:create]

  attr_accessor :messages

  def index
  end

  def get_predefined_instrument_barcodes
    Settings.instrument_processes_without_barcode.reduce({}) do |memo, key_instrument_process|
      instrument_process = InstrumentProcess.find_by_key(key_instrument_process)
      memo[instrument_process.id] = instrument_process.instruments.first.barcode
      memo
    end
  end

  def new
    @predefined_instrument_barcodes = get_predefined_instrument_barcodes
    @process_plate = ProcessPlate.new
  end

  def show_messages(messages)
    unless @messages.nil?
      @messages.keys.each do |facility|
        flash[facility]=@messages[facility].join("\n")
      end
    end
  end

  def create
    @messages = nil
    respond_to do |format|
      bed_verification_model = InstrumentProcessesInstrument.get_bed_verification_type(params[:instrument_barcode],params[:instrument_process])
      if bed_verification_model.nil?
        flash[:error] = "Invalid instrument or process"
      else
        bed_layout_verification = bed_verification_model.new(
          :instrument_barcode => params[:instrument_barcode],
          :scanned_values => params[:robot],
          :api => api
        )
        validation = bed_layout_verification.validate_and_create_audits?(params)
        @messages = bed_layout_verification.messages
        if validation
          bed_layout_verification.add_message(:notice, 'Operation successful')
        else
          bed_layout_verification.add_message(:error, bed_layout_verification.errors.values.flatten.first)
        end
        show_messages(@messages)
      end
      format.html { redirect_to(new_process_plate_path) }
    end
  end

end


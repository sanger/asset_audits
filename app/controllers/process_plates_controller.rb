# frozen_string_literal: true
class ProcessPlatesController < ApplicationController
  require 'wrangler'
  require 'lighthouse'

  skip_before_filter :configure_api, except: [:create]

  attr_accessor :messages

  def index
  end

  def new
    @processes_requiring_visual_check = InstrumentProcess.where(visual_check_required: true).pluck(:id)
    @process_plate = ProcessPlate.new
  end

  def create
    bed_verification_model = InstrumentProcessesInstrument.get_bed_verification_type(
      params[:instrument_barcode],
      params[:instrument_process]
    )
    back_to_new_with_error('Invalid instrument or process') and return if bed_verification_model.nil?

    bed_layout_verification = bed_verification_model.new(
      instrument_barcode: params[:instrument_barcode],
      scanned_values: params[:robot],
      api: api
    )
    unless bed_layout_verification.validate_and_create_audits?(params)
      errors = bed_layout_verification.errors.values.flatten.join("\n")
      back_to_new_with_error(errors) and return
    end

    back_to_new_with_message('Success') and return unless receive_plates_process?(params)

    # the param is called 'source_plates' but we could be working with tube racks or plates etc.
    barcodes = sanitize_barcodes(params[:source_plates])
    unless barcodes && !barcodes.empty?
      back_to_new_with_error('No barcodes were provided') and return
    end

    call_external_services(barcodes)

    @results = parse_responses
    render :results
  end

  def back_to_new_with_message(message, flash_type=:notice)
    flash[flash_type] = message
    redirect_to(new_process_plate_path)
  end

  def back_to_new_with_error(message)
    back_to_new_with_message(message, :error)
  end

  # find out if the 'receive_plates' process was executed
  def receive_plates_process?(params)
    @is_receive_plates_process ||= InstrumentProcess.find_by(id: params[:instrument_process]).key.eql?('slf_receive_plates')
  end

  # Call any external services - currently lighthouse service for plates from Lighthouse Labs and
  #   wrangler for tube racks. If no samples are found in the lighthouse service, try the wrangler
  def call_external_services(barcodes)
    puts "DEBUG: call_external_services"
    # call the lighthouse service first as we are assuming that most labware scanned will be
    #   plates from Lighthouse Labs
    @lighthouse_responses = Lighthouse.call_api(barcodes)
    puts "DEBUG: lighthouse_responses: #{@lighthouse_responses}"

    # keeping it simple for now, if all the responses are not CREATED, send ALL the barcodes
    #   to the wrangler
    @wrangler_responses = Wrangler.call_api(barcodes) unless all_created?(@lighthouse_responses)
    puts "DEBUG: wrangler_responses: #{@wrangler_responses}"
  end

  # Returns a list of unique barcodes by removing blanks and duplicates
  def sanitize_barcodes(barcodes)
    barcodes.split(/\s+/).reject(&:blank?).compact.uniq
  end

  # Checks a list of responses if they are all CREATED (201)
  def all_created?(responses)
    return false if responses.empty?

    responses.all? { |response| response[:code] == "201" }
  end

  def parse_responses
    output = []

    @lighthouse_responses.each do |r|

      barcode = r[:barcode]
      success = if r[:code] == '201'
                  'Yes'
                else
                  'No'
                end
      purpose = r[:purpose]
      study = r[:study]

      output << {
        :barcode => barcode,
        :success => success,
        :purpose => purpose,
        :study => study
      }
    end

    @wrangler_responses.each do |r|

      barcode = r[:barcode]
      success = if r[:code] == '201'
                  'Yes'
                else
                  'No'
                end
      purpose = r[:purpose]
      study = r[:study]

      output << {
        :barcode => barcode,
        :success => success,
        :purpose => purpose,
        :study => study
      }
    end

    output
  end
end

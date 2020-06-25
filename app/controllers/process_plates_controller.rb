# frozen_string_literal: true
class ProcessPlatesController < ApplicationController
  require 'wrangler'
  require 'lighthouse'

  skip_before_action :configure_api, except: [:create]

  attr_accessor :messages

  def index; end

  def new
    @processes_requiring_visual_check = InstrumentProcess.where(visual_check_required: true).pluck(:id)
    @process_plate = ProcessPlate.new
  end

  def create
    bed_verification_model = InstrumentProcessesInstrument.get_bed_verification_type(params[:instrument_barcode], params[:instrument_process])
    raise 'Invalid instrument or process' if bed_verification_model.nil?

    bed_layout_verification = bed_verification_model.new(
      instrument_barcode: params[:instrument_barcode],
      scanned_values: params[:robot],
      api: api
    )
    raise format_errors(bed_layout_verification) unless bed_layout_verification.validate_and_create_audits?(params)

    back_to_new_with_message('Success') && return unless receive_plates_process?(params)

    # here on is relevant to 'receiving plates' only
    # the param is called 'source_plates' but we could be working with tube racks or plates etc.
    barcodes = sanitize_barcodes(params[:source_plates])
    raise 'No barcodes were provided' if barcodes.empty?

    responses = call_external_services(barcodes)
    @results = generate_results(barcodes, responses)

    flash[:notice] = "Scanned #{bed_layout_verification.process_plate&.num_unique_barcodes} barcodes."
    render :results
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to(new_process_plate_path)
  end

  def format_errors(obj)
    obj.errors.values.flatten.join("\n")
  end

  def back_to_new_with_message(message, flash_type = :notice)
    flash[flash_type] = message
    redirect_to(new_process_plate_path)
  end

  # find out if the 'receive_plates' process was executed
  def receive_plates_process?(params)
    @receive_plates_process ||= InstrumentProcess.find_by(id: params[:instrument_process]).key.eql?('slf_receive_plates')
  end

  # Call any external services - currently lighthouse service for plates from Lighthouse Labs and
  # wrangler for tube racks. If no samples are found in the lighthouse service, try the wrangler
  def call_external_services(barcodes)
    output = { lighthouse: [], wrangler: [] }
    # call the lighthouse service first as we are assuming that most labware scanned will be
    #   plates from Lighthouse Labs
    output[:lighthouse] = Lighthouse.call_api(barcodes)

    # keeping it simple for now, if all the responses are not CREATED, send ALL the barcodes
    #   to the wrangler
    output[:wrangler] = Wrangler.call_api(barcodes) unless all_created?(output[:lighthouse])

    output
  end

  # Returns a list of unique barcodes by removing blanks and duplicates
  def sanitize_barcodes(barcodes)
    barcodes.split(/\s+/).reject(&:blank?).compact.uniq
  end

  # Checks a list of responses if they are all CREATED (201)
  def all_created?(responses)
    return false if responses.empty?

    responses.all? { |response| response[:code] == '201' }
  end

  def generate_results(barcodes, responses)
    output = {}
    # default 'success' for each barcode to 'No'
    barcodes.each { |b| output[b] = { success: 'No' } }

    # loop through service responses to update 'output' with successes
    # puts "DEBUG: responses: #{JSON.pretty_generate(responses)}"
    responses[:lighthouse]&.select { |r| r[:code] == '201' }&.each do |r|
      output[r[:barcode]] = parse_response(r, :Lighthouse)
    end
    responses[:wrangler]&.select { |r| r[:code] == '201' }&.each do |r|
      output[r[:barcode]] = parse_response(r, :CGaP)
    end

    output
  end

  def parse_response(response, service)
    {
      success: 'Yes',
      source: service,
      purpose: response.dig(:body, 'data', 'attributes', 'purpose_name'),
      study: response.dig(:body, 'data', 'attributes', 'study_names')&.join(', ')
    }
  end

  def all_labware_created?(results)
    return false if results.any? { |_barcode, details| details[:success] == 'No' }

    true
  end
end

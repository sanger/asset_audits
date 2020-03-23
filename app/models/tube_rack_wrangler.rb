# frozen_string_literal: true

class TubeRackWrangler
  require 'net/http'

  def self.check_process_and_call_api(params)
    return unless InstrumentProcess.find_by(id: params[:instrument_process]).key.eql?('slf_receive_plates')

    plate_barcodes = [params[:source_plates]].map do |s|
      s.split(/\s/).reject(&:blank?)
    end
    plate_barcodes = plate_barcodes.flatten.uniq

    begin
      response_array = []
      plate_barcodes.each do |plate_barcode|
        url = URI.parse("#{Rails.application.config.tube_rack_wrangler_url}/#{plate_barcode}")
        Rails.logger.debug("Trying GET to: #{url}")
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
        response_array << { barcode: plate_barcode, response_code: res.code }
      end
      Rails.logger.info("Sent GET requests to wrangler: #{response_array}")
      response_array
    rescue => exception
      Rails.logger.error(exception)
      return
    end
  end
end

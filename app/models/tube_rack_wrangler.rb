# frozen_string_literal: true

class TubeRackWrangler
  require 'net/http'

  def self.check_process_and_call_api(params)
    return unless InstrumentProcess.find_by(id: params[:instrument_process]).key.eql?('slf_receive_plates')

    plate_barcodes = [params[:source_plates]].map do |s|
      s.split(/\s/).reject(&:blank?)
    end
    plate_barcodes = plate_barcodes.flatten

    plate_barcodes.each_with_object({}) do |plate_barcode, return_hash|
      url = URI.parse("#{Rails.application.config.tube_rack_wrangler_url}/#{plate_barcode}")
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      return_hash[plate_barcode] = res.code
    end
  end
end

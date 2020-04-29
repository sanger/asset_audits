# frozen_string_literal: true

class Wrangler
  require 'net/http'

  def self.call_api(barcodes)
    response_array = []

    barcodes.each do |barcode|
      url = URI.parse("#{Rails.application.config.wrangler_url}/#{barcode}")

      Rails.logger.debug("Trying GET to: #{url}")

      req = Net::HTTP::Get.new(url.to_s)

      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end

      response_array << { barcode: barcode, response_code: res.code }
    end

    Rails.logger.info("Sent GET requests to wrangler: #{response_array}")

    response_array
  rescue StandardError => e
    Rails.logger.error(e)
    nil
  end
end

# frozen_string_literal: true

class Lighthouse
  require 'net/http'
  require 'json'

  def self.call_api(barcodes)
    response_array = []

    barcodes.each do |barcode|
      url = URI.parse("#{Rails.application.config.lighthouse_host}/plates/new")

      Rails.logger.debug("Trying POST to '#{url}' with barcode '#{barcode}'")

      req = Net::HTTP::Post.new(url.to_s, 'Content-Type' => 'application/json')
      req.body = { barcode: barcode }.to_json

      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end

      response_array << { response_code: res.code, response_body: res.body }
    end

    Rails.logger.info("Sent POST requests to lighthouse service: #{response_array}")

    response_array
  rescue StandardError => e
    Rails.logger.error(e)
    nil
  end
end

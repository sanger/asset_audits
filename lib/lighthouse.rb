# frozen_string_literal: true

class Lighthouse
  require 'net/http'
  require 'json'

  def self.call_api(barcodes)
    responses = []

    begin
      barcodes.each do |barcode|
        url = URI.parse("#{Rails.application.config.lighthouse_host}/plates/new")

        Rails.logger.debug("Trying POST to '#{url}' with barcode '#{barcode}'")

        req = Net::HTTP::Post.new(url.to_s, 'Content-Type' => 'application/json')
        req.body = { barcode: barcode }.to_json

        res = Net::HTTP.start(url.host, url.port) do |http|
          http.request(req)
        end

        responses << { code: res.code, body: res.body }
      end
    rescue StandardError => e
      Rails.logger.error(e)
      nil
    else
      Rails.logger.info("Sent POST requests to lighthouse service: #{responses}")
    end
    responses
  end
end

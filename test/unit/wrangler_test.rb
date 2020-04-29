# frozen_string_literal: true

require 'test_helper'
require 'wrangler'

class WranglerTest < ActiveSupport::TestCase
  context 'Only call wranger API if a plate is received' do
    setup do
      ipi = FactoryBot.create(:instrument_processes_instrument)
      @instrument = ipi.instrument
      @instrument_process = ipi.instrument_process

      @input_params = {
        instrument_process: @instrument_process.id.to_s,
        source_plates: 'barcode_one'
      }
      @barcode = @input_params[:source_plates]
    end

    context "when the instrument process is 'receive plates' it" do
      setup do
        # Update the key of the instrument process to the one we are interested in
        @instrument_process.update_attribute(:key, 'slf_receive_plates')
      end

      should 'call the wrangler API for one plate barcode' do
        uri_template = Addressable::Template.new(
          "#{Rails.application.config.wrangler_url}/{barcode}"
        )

        stub_request(:any, uri_template).to_return(status: 200)

        assert_equal(
          Wrangler.call_api([@input_params[:source_plates]]),
          [{ barcode: @barcode, response_code: '200' }]
        )
      end

      should 'call the API for multiple unique plate barcodes' do
        barcodes = %w[barcode_one barcode_two barcode_three]

        uri_template = Addressable::Template.new(
          "#{Rails.application.config.wrangler_url}/{barcode}"
        )

        stub_request(:any, uri_template).to_return(status: 200)

        assert_equal(
          Wrangler.call_api(barcodes),
          [
            { barcode: 'barcode_one', response_code: '200' },
            { barcode: 'barcode_two', response_code: '200' },
            { barcode: 'barcode_three', response_code: '200' }
          ]
        )
      end
    end
  end
end

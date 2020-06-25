# frozen_string_literal: true

require 'test_helper'
require 'lighthouse'

class LighthouseTest < ActiveSupport::TestCase
  context 'Only call lighthouse API if a plate is received' do
    setup do
      ipi = FactoryBot.create(:instrument_processes_instrument)
      @instrument = ipi.instrument
      @instrument_process = ipi.instrument_process

      @input_params = {
        instrument_process: @instrument_process.id.to_s,
        source_plates: 'barcode_one'
      }
    end

    context "when the instrument process is 'receive plates' it" do
      setup do
        # Update the key of the instrument process to the one we are interested in
        @instrument_process.update_attribute(:key, 'slf_receive_plates')
      end

      should 'call the lighthouse API for one plate barcode' do
        uri_template = Addressable::Template.new(
          "#{Rails.application.config.lighthouse_host}/plates/new"
        )

        stub_request(:any, uri_template).to_return(status: 201)

        assert_equal(
          [{ barcode: 'barcode_one', code: '201', body: '' }],
          Lighthouse.call_api([@input_params[:source_plates]])
        )
      end

      should 'call the API for multiple unique plate barcodes' do
        barcodes = %w[barcode_one barcode_two barcode_three]

        uri_template = Addressable::Template.new(
          "#{Rails.application.config.lighthouse_host}/plates/new"
        )

        stub_request(:any, uri_template).to_return(status: 201)

        assert_equal(
          [
            { barcode: 'barcode_one', code: '201', body: '' },
            { barcode: 'barcode_two', code: '201', body: '' },
            { barcode: 'barcode_three', code: '201', body: '' }
          ],
          Lighthouse.call_api(barcodes)
        )
      end
    end
  end
end

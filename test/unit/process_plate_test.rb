# frozen_string_literal: true

require "test_helper"
require "support/mock_sequencescape_v2"

class ProcessPlateTest < ActiveSupport::TestCase
  context "Generating remote asset audits" do
    setup do
      ipi = FactoryBot.create(:instrument_processes_instrument)
      @instrument = ipi.instrument
      @instrument_process = ipi.instrument_process
    end

    context "where all parameters are valid" do
      setup do
        User.stubs(:login_from_user_code).with("123").returns("abc")
        User.stubs(:login_from_user_code).with("456").returns("def")

        @process_plate =
          ProcessPlate.new(
            user_barcode: "123",
            instrument_barcode: @instrument.barcode.to_s,
            source_plates: "DN456S",
            visual_check: false,
            instrument_process_id: @instrument.instrument_processes.first.id.to_s,
            witness_barcode: "456",
            metadata: {
              "bed 1" => "plate 1"
            }
          )

        plate_uuid = "dab1b0ce-3794-11ef-a6f5-26ddcd6c52d7"
        @plate_request = MockSequencescapeV2.mock_get_plate(@process_plate.source_plates, { uuid: plate_uuid })
        @asset_audit_request =
          MockSequencescapeV2.mock_post_asset_audit(
            {
              data: {
                type: "asset_audits",
                attributes: {
                  key: @instrument_process.key,
                  message:
                    "Process '#{@process_plate.instrument_process.name}' performed on instrument #{@instrument.name}",
                  created_by: "abc",
                  asset_uuid: plate_uuid,
                  witnessed_by: "def",
                  metadata: {
                    "bed 1" => "plate 1"
                  }
                }
              }
            }.to_json
          )
      end

      should "submits remote asset audits" do
        @process_plate.save
        @process_plate.create_audits_without_delay

        assert_requested(@plate_request)
        assert_requested(@asset_audit_request)
      end
    end
  end
end

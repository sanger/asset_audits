# frozen_string_literal: true

require 'test_helper'
require 'lighthouse'
require 'wrangler'

class ProcessPlatesControllerTest < ActiveSupport::TestCase
  context 'while testing public functions' do
    should 'sanitize barcodes' do
      assert_equal(ProcessPlatesController.new.sanitize_barcodes('123     456'), %w[123 456])
      assert_equal(ProcessPlatesController.new.sanitize_barcodes('123 456'), %w[123 456])
      assert_equal(ProcessPlatesController.new.sanitize_barcodes('123 123 456'), %w[123 456])
      assert_equal(ProcessPlatesController.new.sanitize_barcodes("123\n456"), %w[123 456])
    end

    should 'verify all responses are HTTP CREATED (201)' do
      assert_equal(ProcessPlatesController.new.all_created?([]), false)
      assert_equal(ProcessPlatesController.new.all_created?([{ code: '201' }, { code: '201' }]), true)
      assert_equal(ProcessPlatesController.new.all_created?([{ code: 201 }, { code: 201 }]), false)
      assert_equal(ProcessPlatesController.new.all_created?([{ code: '201' }, { code: '200' }]), false)
    end

    should 'call external services 1' do
      Lighthouse.expects(:call_api).with(%w[123 456]).returns([])
      Wrangler.expects(:call_api).with(%w[123 456])
      ProcessPlatesController.new.call_external_services(%w[123 456])
    end

    should 'call external services 2' do
      Lighthouse.expects(:call_api).with(%w[123 456]).returns([{ code: 400 }])
      Wrangler.expects(:call_api).with(%w[123 456])
      ProcessPlatesController.new.call_external_services(%w[123 456])
    end

    should 'call only lighthouse service' do
      Lighthouse.expects(:call_api).returns([{ code: '201' }])
      ProcessPlatesController.new.call_external_services(%w[123 456])
    end
  end
end

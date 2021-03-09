# frozen_string_literal: true

require 'test_helper'

class ProcessPlatesControllerTest < ActiveSupport::TestCase
  context 'while testing public functions' do
    should 'sanitize barcodes' do
      assert_equal(ProcessPlatesController.new.sanitize_barcodes('123     456'), %w[123 456])
      assert_equal(ProcessPlatesController.new.sanitize_barcodes('123 456'), %w[123 456])
      assert_equal(ProcessPlatesController.new.sanitize_barcodes('123 123 456'), %w[123 456])
      assert_equal(ProcessPlatesController.new.sanitize_barcodes("123\n456"), %w[123 456])
    end
  end
end

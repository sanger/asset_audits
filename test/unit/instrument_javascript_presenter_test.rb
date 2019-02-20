# frozen_string_literal: true
require 'test_helper'
class InstrumentJavascriptPresenterTest < ActiveSupport::TestCase
  context 'nx assay plate' do
    setup do
      @js_helper = InstrumentJavascriptPresenter.new(Verification::AssayPlate::Nx)
    end

    should 'return the expected array for tab order' do
      assert_equal [
        ['p4_bed', 'p4_plate'],
        ['p4_plate', 'p5_bed'],
        ['p5_bed', 'p5_plate'],
        ['p5_plate', 'p6_bed'],
        ['p6_bed', 'p6_plate'],
        ['p6_plate', 'witness_barcode']
      ], @js_helper.tab_order
    end

    should 'return the expected array for highlighting' do
      assert_equal [[4, 0], [5, 1], [6, 2]], @js_helper.bed_columns
    end

    should 'return the expected value for the initial bed' do
      assert_equal 'p4_bed', @js_helper.initial_bed
    end
  end

  context 'fx assay plate' do
    setup do
      @js_helper = InstrumentJavascriptPresenter.new(Verification::AssayPlate::Fx)
    end

    should 'return the expected array for tab order' do
      assert_equal [
        ['p6_bed', 'p6_plate'],
        ['p6_plate', 'p7_bed'],
        ['p7_bed', 'p7_plate'],
        ['p7_plate', 'p8_bed'],
        ['p8_bed', 'p8_plate'],
        ['p8_plate', 'witness_barcode']
      ], @js_helper.tab_order
    end

    should 'return the expected array for highlighting' do
      assert_equal [[6, 0], [7, 1], [8, 2]], @js_helper.bed_columns
    end

    should 'return the expected value for the initial bed' do
      assert_equal 'p6_bed', @js_helper.initial_bed
    end
  end

  context 'nx dilution plate' do
    setup do
      @js_helper = InstrumentJavascriptPresenter.new(Verification::DilutionPlate::Nx)
    end

    should 'return the expected array for tab order' do
      assert_equal [
        ['p2_bed', 'p2_plate'],
        ['p2_plate', 'p3_bed'],
        ['p3_bed', 'p3_plate'],
        ['p3_plate', 'p5_bed'],
        ['p5_bed', 'p5_plate'],
        ['p5_plate', 'p6_bed'],
        ['p6_bed', 'p6_plate'],
        ['p6_plate', 'p8_bed'],
        ['p8_bed', 'p8_plate'],
        ['p8_plate', 'p9_bed'],
        ['p9_bed', 'p9_plate'],
        ['p9_plate', 'p11_bed'],
        ['p11_bed', 'p11_plate'],
        ['p11_plate', 'p12_bed'],
        ['p12_bed', 'p12_plate'],
        ['p12_plate', 'witness_barcode']
      ], @js_helper.tab_order
    end

    should 'return the expected array for highlighting' do
      assert_equal [[2, 0], [3, 0], [5, 1], [6, 1], [8, 2], [9, 2], [11, 3], [12, 3]], @js_helper.bed_columns
    end

    should 'return the expected value for the initial bed' do
      assert_equal 'p2_bed', @js_helper.initial_bed
    end
  end

  context 'fx dilution plate' do
    setup do
      @js_helper = InstrumentJavascriptPresenter.new(Verification::DilutionPlate::Fx)
    end

    should 'return the expected array for tab order' do
      assert_equal [
        ['p3_bed', 'p3_plate'],
        ['p3_plate', 'p4_bed'],
        ['p4_bed', 'p4_plate'],
        ['p4_plate', 'p7_bed'],
        ['p7_bed', 'p7_plate'],
        ['p7_plate', 'p8_bed'],
        ['p8_bed', 'p8_plate'],
        ['p8_plate', 'p10_bed'],
        ['p10_bed', 'p10_plate'],
        ['p10_plate', 'p11_bed'],
        ['p11_bed', 'p11_plate'],
        ['p11_plate', 'p14_bed'],
        ['p14_bed', 'p14_plate'],
        ['p14_plate', 'p12_bed'],
        ['p12_bed', 'p12_plate'],
        ['p12_plate', 'witness_barcode']
      ], @js_helper.tab_order
    end

    should 'return the expected array for highlighting' do
      assert_equal [[3, 0], [4, 0], [7, 1], [8, 1], [10, 2], [11, 2], [14, 3], [12, 3]], @js_helper.bed_columns
    end

    should 'return the expected value for the initial bed' do
      assert_equal 'p3_bed', @js_helper.initial_bed
    end
  end
end

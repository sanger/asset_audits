# frozen_string_literal: true

require "test_helper"
require "./lib/record_loader/instrument_process_loader"
require "./lib/record_loader/instrument_loader"
require "./lib/record_loader/instrument_processes_instrument_loader"
require "./lib/record_loader/bed_loader"

# Test for the Beckman i5 96 2 instrument Working dilution bed verification.
class BeckmanI59602Test < ActiveSupport::TestCase
  setup do
    # Load the Beckman i5 96-02 records.
    config_folders = [
      'instruments',
      'instrument_processes',
      'instrument_processes_instruments',
      'beds'
    ]
    config_folders.each do |folder|
      # Find the directory and files to load.
      directory = Rails.root.join("config/default_records/#{folder}")
      files = Dir.glob(directory.join("*beckman_i5_96_02*")).map do |file|
        # Find the relative path and remove the extension.
        Pathname.new(file).relative_path_from(directory).sub_ext('').to_s
      end
      # Find the record loader class name, create an instance, and load records.
      class_name = "RecordLoader::#{folder.singularize.camelize}Loader"
      record_loader = class_name.constantize.new(directory:, files:)
      record_loader.create!
    end

    # Find the instrument and instrument process.
    @instrument = Instrument.find_by!(name: "Beckman i5 96-02")
    @instrument_process = InstrumentProcess.find_by!(name: "Working dilution")

    # Find the beds for the instrument and put them into a hash by bed_number.
    @beds = Bed.where(instrument_id: @instrument.id).index_by(&:bed_number)

    # Create the plates and stub Sequencescape API calls.
    @parent_plate = FactoryBot.create(:v2_plate, barcode: "parent-barcode")
    @child_plate = FactoryBot.create(:v2_plate_with_parent,
      barcode: "child-barcode", parent_barcode: "parent-barcode")

    Sequencescape::Api::V2::Plate.stubs(:where)
      .with(barcode: "parent-barcode").returns([@parent_plate])
    Sequencescape::Api::V2::Plate.stubs(:where)
      .with(barcode: "child-barcode").returns([@child_plate])
  end

  def create_input_params(source_bed_no, source_plate, dest_bed_no, dest_plate)
    {
      user_barcode: "user-barcode",
      instrument_barcode: @instrument.barcode.to_s,
      instrument_process: @instrument_process.id.to_s,
      robot: {
        p2: { bed: @beds[source_bed_no].barcode, plate: source_plate },
        p3: { bed: "", plate: "" },
        p4: { bed: "", plate: "" },
        p5: { bed: "", plate: "" },
        p7: { bed: @beds[dest_bed_no].barcode, plate: dest_plate },
        p8: { bed: "", plate: "" },
        p9: { bed: "", plate: "" },
        p10: { bed: "", plate: ""}
      }
    }
  end

  context 'when valid barcodes are scanned' do
    setup do

      # Define the input form parameters.
      @input_params = create_input_params(2, "parent-barcode", 7, "child-barcode")

      # Store the old number of jobs in the delayed job queue.
      @old_delayed_job_count = Delayed::Job.count

      # Store the old number of process plates records.
      @old_process_plate_count = ProcessPlate.count

      # Create the bed layout verification.
      @bed_layout_verification = Verification::DilutionPlate::I5.new(
        instrument_barcode: @input_params[:instrument_barcode],
        scanned_values: @input_params[:robot]
      )

      # Expect user login and stub the method call.
      User.expects(:login_from_user_code).with(@input_params[:user_barcode]).returns("user-login")

      # Run validation.
      @bed_layout_verification.validate_and_create_audits?(@input_params)

      # Store the new number of jobs in the delayed job queue.
      @new_delayed_job_count = Delayed::Job.count


    end

    should "not have any errors" do
      assert_empty @bed_layout_verification.errors
    end

    should "create delayed job for audits" do
      assert_equal @old_delayed_job_count + 1, @new_delayed_job_count
    end

    should "create a process plate record" do
      expect(ProcessPlate.last).to have_attributes(
          user_barcode: "user-barcode",
          instrument_barcode: @instrument.barcode.to_s,
          source_plates: "parent-barcode child-barcode",
          instrument_process_id: @instrument.instrument_processes.first.id,
          visual_check: false,
          metadata: {
            "scanned" => {
              "p2" => {
                "bed" => @beds[2].barcode,
                "plate" => "parent-barcode"
              },
              "p7" => {
                "bed" => @beds[7].barcode,
                "plate" => "child-barcode"
              }
            }
          }
        )
    end
  end

  context 'when invalid barcodes are scanned' do
    setup do
      # Define the input form parameters. Swap parent and child beds.
      @input_params = create_input_params(2, "child-barcode", 7, "parent-barcode")

      # Store the old number of jobs in the delayed job queue.
      @old_delayed_job_count = Delayed::Job.count

      # Create the bed layout verification.
      @bed_layout_verification = Verification::DilutionPlate::I5.new(
        instrument_barcode: @input_params[:instrument_barcode],
        scanned_values: @input_params[:robot]
      )

      # Expect user login and stub the method call.
      User.expects(:login_from_user_code).at_least(0).with(@input_params[:user_barcode]).returns("user-login")

      # Run validation.
      @bed_layout_verification.validate_and_create_audits?(@input_params)

      # Store the new number of jobs in the delayed job queue.
      @new_delayed_job_count = Delayed::Job.count
    end

    should "have an error" do
      error_message = "Invalid source plate layout: " \
      "child-barcode is not a parent of parent-barcode. " \
      "parent-barcode has no known parents."

      assert_includes @bed_layout_verification.errors[:base], error_message
    end

    should "not create delayed job for audits" do
      assert_equal @old_delayed_job_count, @new_delayed_job_count
    end
  end
end

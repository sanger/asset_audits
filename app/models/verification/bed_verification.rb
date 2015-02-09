module Verification::BedVerification

  def self.included(base)
    base.class_eval do
      validates_with Verification::Validator::PlatesScanned
      validates_with Verification::Validator::BedsAndPlatesScanned
      validates_with Verification::Validator::SourceAndDestinationPlatesLinked
    end
  end

  def validate_and_create_audits?(params)
    return false unless valid?
    params[:source_plates] = parse_source_and_destination_barcodes(scanned_values).flatten.join(" ")
    return super(params)
  end

end


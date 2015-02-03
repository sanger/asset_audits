module Verification::BedVerification

  def validate_and_create_audits?(params)
    return false unless valid?
    params[:source_plates] = parse_source_and_destination_barcodes(scanned_values).flatten.join(" ")
    return super(params)
  end

end


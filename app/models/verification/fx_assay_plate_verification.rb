class Verification::FxAssayPlateVerification < Verification::AssayPlateVerification
  include Verification::BedVerification
  
  self.source_beds      = ['P6']
  self.destination_beds = ['P7','P8']

  def self.javascript_partial_name
    "fx_assay_plate_javascript"
  end
  
end


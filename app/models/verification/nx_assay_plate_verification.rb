class Verification::NxAssayPlateVerification < Verification::AssayPlateVerification
  include Verification::BedVerification
  self.source_beds      = ['P4']
  self.destination_beds = ['P5','P6']
  
  # migration in deployment app
  # FX

  def self.javascript_partial_name
    "nx_assay_plate_javascript"
  end
  
end


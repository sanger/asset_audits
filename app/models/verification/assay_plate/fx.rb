class Verification::AssayPlate::Fx < Verification::AssayPlate::Base
  self.source_beds      = ['P6']
  self.destination_beds = ['P7','P8']
  self.javascript_partial_name = "fx_assay_plate_javascript"
end

class Verification::AssayPlate::Nx < Verification::AssayPlate::Base
  self.source_beds      = ['P4']
  self.destination_beds = ['P5','P6']
  self.javascript_partial_name = "nx_assay_plate_javascript"
end

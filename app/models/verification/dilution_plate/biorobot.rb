class Verification::DilutionPlate::Biorobot < Verification::DilutionPlate::Fx
  self.source_beds      = ['P1']
  self.destination_beds = ['P2']
  self.javascript_partial_name = "fx_dilution_plate_javascript"
end

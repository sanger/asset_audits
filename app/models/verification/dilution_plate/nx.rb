class Verification::DilutionPlate::Nx < Verification::DilutionPlate::Base
  self.source_beds      = %w(P2 P5 P8 P11)
  self.destination_beds = %w(P3 P6 P9 P12)
  
  def self.javascript_partial_name
    "nx_dilution_plate_javascript"
  end
end

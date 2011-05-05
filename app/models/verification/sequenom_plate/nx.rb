class Verification::SequenomPlate::Nx < Verification::SequenomPlate::Base
  self.source_beds      = ['P2','P5', 'P8', 'P11']
  self.destination_beds = ['P3','P6', 'P9', 'P12']
  
  def self.javascript_partial_name
    "nx_sequenom_plate_javascript"
  end
end

class Verification::DilutionPlate::QiagenBiorobot < Verification::DilutionPlate::Fx
  self.source_beds      = ['P6', 'P7']
  self.destination_beds = ['P1', 'P3']

  def self.javascript_partial_name
    "fx_dilution_plate_javascript"
  end
end

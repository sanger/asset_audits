# frozen_string_literal: true

class Verification::DilutionPlate::Biorobot < Verification::DilutionPlate::Fx
  self.source_beds = ['P1']
  self.destination_beds = ['P2']
end

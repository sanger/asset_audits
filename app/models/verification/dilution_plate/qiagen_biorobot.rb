# frozen_string_literal: true

class Verification::DilutionPlate::QiagenBiorobot < Verification::DilutionPlate::Fx
  self.source_beds = %w[P6 P7]
  self.destination_beds = %w[P1 P3]
end

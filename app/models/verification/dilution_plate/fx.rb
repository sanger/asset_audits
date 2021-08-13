# frozen_string_literal: true

class Verification::DilutionPlate::Fx < Verification::DilutionPlate::Base
  # last beds are not a typo, its a legacy setup on the robot
  self.source_beds      = %w(P3 P7 P10 P14)
  self.destination_beds = %w(P4 P8 P11 P12)
end

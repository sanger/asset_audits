# frozen_string_literal: true
class Verification::SequenomPlate::Nx < Verification::SequenomPlate::Base
  self.source_beds      = %w(P2 P5 P8 P11)
  self.destination_beds = %w(P3 P6 P9 P12)
end

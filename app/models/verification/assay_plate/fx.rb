# frozen_string_literal: true

class Verification::AssayPlate::Fx < Verification::AssayPlate::Base
  self.source_beds = ["P6"]
  self.destination_beds = %w[P7 P8]
end

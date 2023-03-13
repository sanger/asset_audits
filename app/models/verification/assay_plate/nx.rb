# frozen_string_literal: true

class Verification::AssayPlate::Nx < Verification::AssayPlate::Base
  self.source_beds = ["P4"]
  self.destination_beds = %w[P5 P6]
end

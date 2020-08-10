# frozen_string_literal: true

# Either 1 or 2 plates can be processed at a time.
class Verification::DilutionPlate::Hamilton < Verification::DilutionPlate::Base
  self.source_beds      = %w[P4 P5]
  self.destination_beds = %w[P34 P35]
end

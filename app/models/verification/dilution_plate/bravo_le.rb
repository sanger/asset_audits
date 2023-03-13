# frozen_string_literal: true

# This configuration is for Sample Management Bravo Lysates Extraction
class Verification::DilutionPlate::BravoLe < Verification::DilutionPlate::Base
  self.source_beds = %w[P4]
  self.destination_beds = %w[P14]
end

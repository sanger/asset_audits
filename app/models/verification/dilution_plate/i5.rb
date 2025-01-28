# frozen_string_literal: true

# This class is used to define the specific source and destination beds for the
# I5 dilution plate verification process
class Verification::DilutionPlate::I5 < Verification::DilutionPlate::Base
  self.source_beds = %w[P2 P3 P4 P5]
  self.destination_beds = %w[P7 P8 P9 P10]
end

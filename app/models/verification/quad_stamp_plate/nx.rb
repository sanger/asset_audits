# frozen_string_literal: true

# Instrument: NX-96

# Positions:
# Source Rack 1 = Bed 2
# Source Rack 2 = Bed 5
# Source Rack 3 = Bed 8
# Source Rack 4 = Bed 11
# Destination Plate = Bed 3

# Source rack 1 transferred to A1 quadrant
# Source rack 2 transferred to B1 quadrant
# Source rack 3 transferred to A2 quadrant
# Source rack 4 transferred to B2 quadrant

class Verification::QuadStampPlate::Nx < Verification::QuadStampPlate::Base
  self.source_beds = %w[P2 P5 P8 P11] # NB. in quadrant order 1-4
  self.destination_beds = %w[P3]
end

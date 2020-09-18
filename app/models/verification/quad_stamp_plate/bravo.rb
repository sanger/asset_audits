# frozen_string_literal: true

# Instrument: Bravo

# Positions:
# Source Rack 1 = Bed 1
# Source Rack 2 = Bed 4
# Source Rack 3 = Bed 3
# Source Rack 4 = Bed 6
# Destination Plate = Bed 5

# Source rack 1 transferred to A1 quadrant
# Source rack 2 transferred to B1 quadrant
# Source rack 3 transferred to A2 quadrant
# Source rack 4 transferred to B2 quadrant

class Verification::QuadStampPlate::Bravo < Verification::QuadStampPlate::Base
  self.source_beds      = %w[P1 P4 P3 P6] # NB. in quadrant order 1-4
  self.destination_beds = %w[P5]
end

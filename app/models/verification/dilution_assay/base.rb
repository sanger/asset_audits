# frozen_string_literal: true

# Inherited by {Verification::DilutionAssay::NxGroup} which configures the beds
# used.
# Validates the transfer of one to two source plate onto a destination plate
# and the simultaneous transfer of those destination plates onto two destination
# plates each.
#
# s1 --> d1--> d1a    s2 --> d2--> d2a
#         \--> d1b            \--> d2b
class Verification::DilutionAssay::Base < Verification::Base
  include Verification::BedVerification
  validates_with Verification::Validator::SourceAndDestinationPlatesScanned

  include Verification::Groupable
end

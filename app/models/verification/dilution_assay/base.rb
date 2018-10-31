class Verification::DilutionAssay::Base < Verification::Base
  include Verification::BedVerification
  validates_with Verification::Validator::SourceAndDestinationPlatesScanned

  include Verification::Groupable
end

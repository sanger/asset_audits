class Verification::DilutionAssay::Base < Verification::Base
  include Verification::BedVerification
  validates_with Verification::Validator::SourceAndDestinationPlatesScanned
  validates_with Verification::Validator::AllDestinationPlatesScanned

  include Verification::Groupable
end

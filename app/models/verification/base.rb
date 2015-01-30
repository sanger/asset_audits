class Verification::Base < Verification:WithoutBedValidations
  validates_with Verification::Validator::PlatesScanned
  validates_with Verification::Validator::BedsAndPlatesScanned
  validates_with Verification::Validator::SourceAndDestinationPlatesLinked
end

class Verification::DilutionAssay::Nx < Verification::DilutionAssay::Base
  def self.transfers
    [
      {
    :source_beds => ['P2'],
    :destination_beds => ['P3'],
    :priority => 1,
    :group => 1
    },
    {
     :source_beds => ['P3'],
     :destination_beds => ['P5', 'P6'],
     :priority => 2,
     :group => 1
    }]
  end

end

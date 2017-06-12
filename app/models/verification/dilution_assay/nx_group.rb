class Verification::DilutionAssay::NxGroup < Verification::DilutionAssay::Base
  def self.transfers
    [
      {
        source_beds: ['P2'],
        destination_beds: ['P3'],
        priority: 1,
        group: 1
      },
      {
        source_beds: ['P3'],
        destination_beds: ['P5', 'P6'],
        priority: 2,
        group: 1
      },
      {
        source_beds: ['P8'],
        destination_beds: ['P9'],
        priority: 1,
        group: 2
      },
      {
        source_beds: ['P9'],
        destination_beds: ['P11', 'P12'],
        priority: 2,
        group: 2
      }
    ]
  end
end

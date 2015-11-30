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
    },
    {
      :source_beds => ['P8'],
      :destination_beds => ['P9'],
      :priority => 1,
      :group => 2
    }, {
      :source_beds => ['P9'],
      :destination_beds => ['P11', 'P12'],
      :priority => 2,
      :group => 2
    }]
  end

  def self.transfer_groups
    self.transfers.map{|t| t[:group] }.uniq.map do|group_id|
      transfers_of_group = self.transfers.select{|t| t[:group]==group_id}

      transfers_of_group.reduce({
        :group => group_id,
        :source_beds => [],
        :destination_beds => transfers_of_group.map{|t| t[:destination_beds]}.flatten.uniq
      }) do |memo, transfer|
        transfer[:source_beds].each do |source_bed|
          memo[:source_beds] << source_bed unless memo[:destination_beds].include?(source_bed)
        end
        memo
      end
    end
  end

  def self.javascript_partial_name
    "nx_dilution_assay_javascript"
  end
end

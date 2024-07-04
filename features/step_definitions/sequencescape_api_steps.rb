# frozen_string_literal: true

Before do
  @plates = {}
end

Given(/^I can retrieve plates by barcode$/) do
  allow(Sequencescape::Api::V2::Plate).to receive(:where) do |**kwargs|
    barcode = kwargs[:barcode]
    if barcode.is_a?(Array)
      barcode.filter_map { |b| @plates[b] if @plates.key?(b) }
    elsif barcode.is_a?(String)
      [@plates[barcode]].compact
    else
      raise "Unexpected barcode type: #{barcode.class}"
    end
  end
end

Given(/^I have a plate with barcode "(.+?)"$/) do |barcode|
  @plates[barcode] = Sequencescape::Api::V2::Plate.new
end

Given(
  /^I have a destination plate with barcode "(.+?)" and parent barcodes "(.+?)"$/
) do |child_barcode, parent_barcodes|
  parent_barcodes_list = parent_barcodes.split(",")

  parent_labware_list =
    parent_barcodes_list.map do |parent_barcode|
      parent_labware = Sequencescape::Api::V2::Labware.new
      allow(parent_labware).to receive(:labware_barcode).and_return({ "machine_barcode" => parent_barcode.to_s })
      parent_labware
    end

  child_plate = Sequencescape::Api::V2::Plate.new
  allow(child_plate).to receive(:labware_barcode).and_return({ "machine_barcode" => child_barcode.to_s })
  allow(child_plate).to receive(:parents).and_return(parent_labware_list)
  @plates[child_barcode] = child_plate
end

Given(/^I cannot retrieve the plate with barcode "(.+?)"$/) do |barcode|
  @plates.delete(barcode)
end

Given(
  /^I can retrieve the labware with barcodes "(.+?)" and lifespans "(.+?)" and ages "(.+?)" and existence "(.+?)"$/
) do |barcodes, lifespans, ages, existence|
  barcode_list = barcodes.split(",").map(&:strip).compact_blank
  lifespan_list =
    lifespans
      .split(",")
      .compact_blank
      .map do |lifespan|
        lifespan.strip!
        lifespan == "nil" ? nil : lifespan.to_i
      end
  age_list = ages.split(",").compact_blank.map(&:to_i)
  exists_list = existence.split(",").compact_blank.map { |e| e.strip == "true" }

  labware_list = []
  barcode_list.each_with_index do |barcode, index|
    next unless exists_list[index]

    purpose = Sequencescape::Api::V2::Purpose.new
    allow(purpose).to receive(:lifespan).and_return(lifespan_list[index])
    allow(purpose).to receive(:name).and_return("immortal")

    labware = Sequencescape::Api::V2::Labware.new
    allow(labware).to receive(:purpose).and_return(purpose)
    allow(labware).to receive(:labware_barcode).and_return({ "machine_barcode" => barcode.to_s })
    allow(labware).to receive(:created_at).and_return(Time.zone.today - age_list[index])

    labware_list << labware
  end

  allow(Sequencescape::Api::V2::Labware).to receive(:where).with(barcode: barcode_list).and_return(labware_list)
end

Given(/^I can create any asset audits in Sequencescape$/) do
  allow(Sequencescape::Api::V2::AssetAudit).to receive(:create!).and_return(true)
end

# frozen_string_literal: true

Given(/^I can retrieve the plate with barcode "([^"]*)"$/) do |barcode|
  allow(Sequencescape::Api::V2::Plate).to receive(:where).with(barcode: [barcode]).and_return([Sequencescape::Api::V2::Plate.new])
end

Given(/^I can create any asset audits in Sequencescape$/) do
  allow(Sequencescape::Api::V2::AssetAudit).to receive(:create!).and_return(true)
end

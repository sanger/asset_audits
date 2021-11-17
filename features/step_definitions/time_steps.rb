# frozen_string_literal: true

require 'timecop'

Given(/^all this is happening at "(.*?)"$/) do |time|
  Timecop.travel(Time.zone.parse(time)) # express the regexp above with the code you wish you had
end

After('@timecop') { |_s| Timecop.return }

# frozen_string_literal: true

Before("@labwhere_scan_into_destroyed_location_success") do
  stub_request(:post, "http://localhost:3003/api/scans").to_return(status: 200, body: "", headers: {})
end

After("@javascript") do
  # A fresh browser avoids Capybara's wildcard storage reset, rejected by newer Chrome versions.
  Capybara.current_session.driver.quit
end

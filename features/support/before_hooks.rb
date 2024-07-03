# frozen_string_literal: true

Before("@labwhere_scan_into_destroyed_location_success") do
  stub_request(:post, "http://localhost:3003/api/scans").to_return(status: 200, body: "", headers: {})
end

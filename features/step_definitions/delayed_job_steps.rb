# frozen_string_literal: true

Given(/^([1-9]|[1-9]\d+) pending delayed jobs are processed$/) do |count|
  Delayed::Worker.new(quiet: ENV['LOUD_DELAYED_JOBS'].nil?).work_off(count.to_i)
  raise StandardError, "Delayed jobs have failed: #{Delayed::Job.all.map(&:last_error).join('; ')}" if Delayed::Job.all.any? { |j| j.run_at? && j.last_error? }
  raise StandardError, "There are #{Delayed::Job.count} jobs left to process" unless Delayed::Job.count.zero?
end

Given(/^all pending delayed jobs are processed$/) do
  count = Delayed::Job.count
  raise StandardError, 'There are no delayed jobs to process!' if count.zero?

  step %Q{#{count} pending delayed jobs are processed}
end

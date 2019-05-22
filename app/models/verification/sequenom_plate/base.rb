# frozen_string_literal: true
class Verification::SequenomPlate::Base < Verification::Base
  self.partial_name = 'deprecated_process'

  def validate_and_create_audits?(_params)
    # In theory we shouldn't end up here, but this stops us
    # doing something unpredictable if we do.
    errors.add(:base, 'This process has been removed')
    false
  end
end

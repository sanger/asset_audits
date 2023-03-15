# frozen_string_literal: true

#
# Deprecated process previously used for the stamping of 96 well plates
# into a 384 well plate for the Sequenom process in a manner similar to
# {Verification::QuadStampPlate::Base}.
class Verification::SequenomPlate::Base < Verification::Base
  self.partial_name = "deprecated_process"

  def validate_and_create_audits?(_params)
    # In theory we shouldn't end up here, but this stops us
    # doing something unpredictable if we do.
    errors.add(:base, "This process has been removed")
    false
  end
end

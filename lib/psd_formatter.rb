# frozen_string_literal: true

require "syslog/logger"
require "ostruct"

class PsdFormatter < Syslog::Logger::Formatter
  LINE_FORMAT = "(thread-%s) [%s] %5s -- : %s\n"

  def initialize(deployment_info)
    @app_tag = deployment_info.values_at(:version, :environment).compact.join(":").freeze
    super()
  end

  def call(severity, _timestamp, _progname, msg)
    thread_id = Thread.current.object_id
    format(LINE_FORMAT, thread_id, @app_tag, format_severity(severity), msg)
  end

  private

  # Severity label for logging (max 5 chars).
  SEV_LABEL = %w[DEBUG INFO WARN ERROR FATAL ANY].each(&:freeze).freeze

  def format_severity(severity)
    severity.is_a?(Integer) ? SEV_LABEL[severity] || "ANY" : severity
  end
end

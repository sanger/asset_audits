# frozen_string_literal: true

module ApplicationHelper
  def flash_messages(&)
    %i[notice error warning].map { |f| [f, flash[f]] }.compact_blank.map(&)
  end
end

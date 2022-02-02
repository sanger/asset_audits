# frozen_string_literal: true

module ApplicationHelper
  def flash_messages(&block)
    %i[notice error warning].map { |f| [f, flash[f]] }.reject { |_, v| v.blank? }.map(&block)
  end
end

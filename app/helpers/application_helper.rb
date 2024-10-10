# frozen_string_literal: true

module ApplicationHelper
  def flash_messages(&)
    %i[notice error warning].map { |f| [f, flash[f]] }.compact_blank.map(&)
  end

  def fresh_sevice_link
    link_to "FreshService", ProcessTracking::Application.config.fresh_sevice_new_ticket_url
  end
end

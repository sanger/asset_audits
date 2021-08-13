# frozen_string_literal: true

module ApplicationHelper
  def flash_messages(&block)
    [:notice, :error, :warning].map do |f|
      [f, flash[f]]
    end.reject do |_, v|
      v.blank?
    end.map(&block)
  end
end

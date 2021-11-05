# frozen_string_literal: true

module ApplicationHelper
  def flash_messages(&block)
    %i[notice error warning].map do |f|
      [f, flash[f]]
    end.reject do |_, v| # rubocop:todo Style/MultilineBlockChain
      v.blank?
    end.map(&block)
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  def format_errors(obj)
    obj.errors.map(&:message).join("\n")
  end
end

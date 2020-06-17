# frozen_string_literal: true
class UsersController < ApplicationController
  skip_before_action :configure_api

  def search
    render plain: User.login_from_user_code(params[:user_barcode])
  end
end

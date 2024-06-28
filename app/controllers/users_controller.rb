# frozen_string_literal: true

class UsersController < ApplicationController
  def search
    render plain: User.login_from_user_code(params[:user_barcode])
  end
end

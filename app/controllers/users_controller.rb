class UsersController < ApplicationController
  skip_before_filter :configure_api

  def search
    render text: User.login_from_user_code(params[:user_barcode])
  end
end

class UsersController < ApplicationController
   skip_before_filter :configure_api

   def search
     render :text =>  UserBarcode::UserBarcode.find_username_from_barcode(params[:user_barcode])
   end
    
end


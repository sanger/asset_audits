# frozen_string_literal: true
class Admin::BedsController < ApplicationController
  skip_before_action :configure_api

  def create
    bed = Bed.new(bed_params)
    respond_to do |format|
      if bed.save
        flash.notice = 'Bed created'
      else
        flash[:error] = bed.errors.full_messages.join(', ')
      end
      format.html { redirect_to(admin_instrument_path(bed.instrument)) }
    end
  end

  def destroy
    bed = Bed.find(params[:id])
    instrument = bed.instrument
    bed.destroy
    respond_to do |format|
      flash[:notice] = 'Removed bed from instrument'
      format.html { redirect_to(admin_instrument_path(instrument)) }
    end
  end

  def bed_params
    params.require(:bed).permit(:name, :bed_number, :barcode, :instrument_id)
  end
end

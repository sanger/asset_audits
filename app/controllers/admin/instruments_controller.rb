# frozen_string_literal: true

class Admin::InstrumentsController < ApplicationController
  def index
    @instruments = Instrument.all
  end

  def show
    @instrument = Instrument.find(params[:id])
  end

  def new
    @instrument = Instrument.new
  end

  def edit
    @instrument = Instrument.find(params[:id])
  end
  def create
    instrument = Instrument.new(instrument_params)
    respond_to do |format|
      if instrument.save
        flash[:notice] = "Created instrument"
        format.html { redirect_to(admin_instrument_path(instrument)) }
      else
        flash[:error] = "Invalid inputs"
        format.html { redirect_to(new_admin_instrument_path) }
      end
    end
  end

  def update
    instrument = Instrument.find(params[:id])
    respond_to do |format|
      if instrument.update(instrument_params)
        flash[:notice] = "Updated instrument"
        format.html { redirect_to(admin_instrument_path(instrument)) }
      else
        flash[:error] = "Invalid inputs"
        format.html { redirect_to(new_admin_instrument_path) }
      end
    end
  end

  def destroy
    instrument = Instrument.find(params[:id])
    instrument.destroy

    # also remove links
    respond_to do |format|
      flash[:notice] = "Deleted instrument"
      format.html { redirect_to(admin_instruments_path) }
    end
  end

  private

  def instrument_params
    params.require(:instrument).permit(:name, :barcode)
  end
end

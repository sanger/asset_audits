# frozen_string_literal: true

class PlatesController < ApplicationController
  def search
    render plain: ''
    # render :text =>  Plate.sanger_barcodes(params[:source_plates]).join('<br />')
  end
end

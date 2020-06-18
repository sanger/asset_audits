# frozen_string_literal: true
class AddMetadataToProcessPlates < ActiveRecord::Migration[5.2]
  def change
    add_column :process_plates, :metadata, :json
  end
end

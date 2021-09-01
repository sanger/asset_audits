# frozen_string_literal: true

class ChangeSourcePlatesToTextType < ActiveRecord::Migration
  def self.up
    change_column :process_plates, :source_plates, :text
  end

  def self.down
    change_column :process_plates, :source_plates, :string
  end
end

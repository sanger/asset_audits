class AddBedsTable < ActiveRecord::Migration
  def self.up
    create_table :beds, :force => true do |t|
      t.string :name
      t.string :barcode
      t.integer :bed_number
      t.integer :instrument_id
      t.timestamps
    end
    
    add_index :beds, :barcode
    add_index :beds, :bed_number
    add_index :beds, :instrument_id
  end

  def self.down
    drop_table :beds
  end
end
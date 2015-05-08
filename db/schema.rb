# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150202171723) do

  create_table "beds", :force => true do |t|
    t.string   "name"
    t.string   "barcode"
    t.integer  "bed_number"
    t.integer  "instrument_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beds", ["barcode"], :name => "index_beds_on_barcode"
  add_index "beds", ["bed_number"], :name => "index_beds_on_bed_number"
  add_index "beds", ["instrument_id"], :name => "index_beds_on_instrument_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "instrument_processes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
    t.boolean  "request_instrument", :default => true
  end

  add_index "instrument_processes", ["key"], :name => "index_instrument_processes_on_key"

  create_table "instrument_processes_instruments", :force => true do |t|
    t.integer  "instrument_id"
    t.integer  "instrument_process_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "witness"
    t.string   "bed_verification_type"
  end

  add_index "instrument_processes_instruments", ["instrument_id"], :name => "ipi_i"
  add_index "instrument_processes_instruments", ["instrument_process_id"], :name => "ipi_ip"

  create_table "instruments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "barcode"
  end

  add_index "instruments", ["barcode"], :name => "index_instruments_on_barcode"

  create_table "process_plates", :force => true do |t|
    t.string   "user_barcode"
    t.string   "instrument_barcode"
    t.text     "source_plates",         :limit => 255
    t.integer  "instrument_process_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "witness_barcode"
  end

end

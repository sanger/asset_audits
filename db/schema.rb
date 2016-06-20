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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160617123733) do

  create_table "beds", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "barcode",       limit: 255
    t.integer  "bed_number",    limit: 4
    t.integer  "instrument_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beds", ["barcode"], name: "index_beds_on_barcode", using: :btree
  add_index "beds", ["bed_number"], name: "index_beds_on_bed_number", using: :btree
  add_index "beds", ["instrument_id"], name: "index_beds_on_instrument_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0
    t.integer  "attempts",   limit: 4,     default: 0
    t.text     "handler",    limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue",      limit: 255
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "instrument_processes", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key",                   limit: 255
    t.boolean  "request_instrument",            :default => true
    t.boolean  "visual_check_required",         :default => false
    t.float    "volume_to_pick"
  end

  add_index "instrument_processes", ["key"], name: "index_instrument_processes_on_key", using: :btree

  create_table "instrument_processes_instruments", force: :cascade do |t|
    t.integer  "instrument_id",         limit: 4
    t.integer  "instrument_process_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "witness"
    t.string   "bed_verification_type", limit: 255
  end

  add_index "instrument_processes_instruments", ["instrument_id"], name: "ipi_i", using: :btree
  add_index "instrument_processes_instruments", ["instrument_process_id"], name: "ipi_ip", using: :btree

  create_table "instruments", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "barcode",    limit: 255
  end

  add_index "instruments", ["barcode"], name: "index_instruments_on_barcode", using: :btree

  create_table "process_plates", force: :cascade do |t|
    t.string   "user_barcode",          limit: 255
    t.string   "instrument_barcode",    limit: 255
    t.text     "source_plates",         limit: 65535
    t.integer  "instrument_process_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "witness_barcode",       limit: 255
    t.boolean  "visual_check",                        default: false
  end

end

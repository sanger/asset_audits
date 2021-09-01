# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_200_617_163_340) do
  create_table 'beds', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.string 'barcode'
    t.integer 'bed_number'
    t.integer 'instrument_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.index ['barcode'], name: 'index_beds_on_barcode'
    t.index ['bed_number'], name: 'index_beds_on_bed_number'
    t.index ['instrument_id'], name: 'index_beds_on_instrument_id'
  end

  create_table 'delayed_jobs', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.integer 'priority', default: 0
    t.integer 'attempts', default: 0
    t.text 'handler'
    t.text 'last_error'
    t.datetime 'run_at'
    t.datetime 'locked_at'
    t.datetime 'failed_at'
    t.string 'locked_by'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'queue'
    t.index ['priority', 'run_at'], name: 'delayed_jobs_priority'
  end

  create_table 'instrument_processes', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'key'
    t.boolean 'request_instrument', default: true
    t.boolean 'visual_check_required', default: false
    t.float 'volume_to_pick'
    t.index ['key'], name: 'index_instrument_processes_on_key'
  end

  create_table 'instrument_processes_instruments', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.integer 'instrument_id'
    t.integer 'instrument_process_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.boolean 'witness'
    t.string 'bed_verification_type'
    t.index ['instrument_id'], name: 'ipi_i'
    t.index ['instrument_process_id'], name: 'ipi_ip'
  end

  create_table 'instruments', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'barcode'
    t.index ['barcode'], name: 'index_instruments_on_barcode'
  end

  create_table 'process_plates', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'user_barcode'
    t.string 'instrument_barcode'
    t.text 'source_plates'
    t.integer 'instrument_process_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'witness_barcode'
    t.boolean 'visual_check', default: false
    t.json 'metadata'
  end
end

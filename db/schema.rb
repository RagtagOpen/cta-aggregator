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

ActiveRecord::Schema.define(version: 20170404051841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "call_scripts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text     "text"
    t.string   "checksum",   limit: 64
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["checksum"], name: "index_call_scripts_on_checksum", using: :btree
  end

  create_table "contacts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ctas", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "website"
    t.boolean  "free",           default: true
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "action_type"
    t.uuid     "location_id"
    t.uuid     "contact_id"
    t.uuid     "call_script_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "locations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "address",    limit: 1000
    t.string   "city"
    t.string   "state",      limit: 2
    t.string   "zipcode"
    t.text     "notes"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end

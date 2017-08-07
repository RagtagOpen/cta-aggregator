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

ActiveRecord::Schema.define(version: 20170807172203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "advocacy_campaign_targets", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "advocacy_campaign_id"
    t.uuid     "target_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["advocacy_campaign_id"], name: "index_advocacy_campaign_targets_on_advocacy_campaign_id", using: :btree
    t.index ["target_id"], name: "index_advocacy_campaign_targets_on_target_id", using: :btree
  end

  create_table "advocacy_campaigns", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "browser_url"
    t.string   "origin_system"
    t.string   "featured_image_url"
    t.string   "action_type"
    t.text     "template"
    t.uuid     "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "identifiers"
    t.index ["user_id"], name: "index_advocacy_campaigns_on_user_id", using: :btree
  end

  create_table "events", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "browser_url"
    t.string   "origin_system"
    t.string   "featured_image_url"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "free"
    t.uuid     "location_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.uuid     "user_id"
    t.text     "identifiers"
  end

  create_table "locations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text     "address_lines"
    t.string   "locality"
    t.string   "region",        limit: 2
    t.string   "postal_code"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "venue"
    t.uuid     "user_id"
  end

  create_table "targets", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "organization"
    t.string   "given_name"
    t.string   "family_name"
    t.string   "ocdid"
    t.text     "postal_addresses"
    t.text     "email_addresses"
    t.text     "phone_numbers"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.uuid     "user_id"
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "api_key",         null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["api_key"], name: "index_users_on_api_key", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "advocacy_campaign_targets", "advocacy_campaigns"
  add_foreign_key "advocacy_campaign_targets", "targets"
end

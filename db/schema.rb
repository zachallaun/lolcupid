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

ActiveRecord::Schema.define(version: 20160501040938) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "champions", force: :cascade do |t|
    t.integer "champion_id",   null: false
    t.string  "name",          null: false
    t.string  "key",           null: false
    t.string  "title",         null: false
    t.string  "image",         null: false
    t.string  "asset_version"
    t.string  "nickname"
  end

  add_index "champions", ["champion_id"], name: "index_champions_on_champion_id", using: :btree

  create_table "summoners", force: :cascade do |t|
    t.integer  "summoner_id",       limit: 8, null: false
    t.string   "standardized_name",           null: false
    t.string   "display_name",                null: false
    t.integer  "summoner_level"
    t.integer  "tier"
    t.integer  "division"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "first_match"
    t.integer  "profile_icon_id"
    t.datetime "last_scraped_at"
  end

  add_index "summoners", ["standardized_name"], name: "index_summoners_on_standardized_name", using: :btree
  add_index "summoners", ["summoner_id"], name: "index_summoners_on_summoner_id", using: :btree

end

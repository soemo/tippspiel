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

ActiveRecord::Schema.define(version: 20150704110909) do

  create_table "events", force: :cascade do |t|
    t.string   "event_type", limit: 30, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "team1_id",               limit: 4
    t.integer  "team1_goals",            limit: 4
    t.integer  "team2_id",               limit: 4
    t.integer  "team2_goals",            limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "lock_version",           limit: 4,   default: 0
    t.string   "round",                  limit: 30
    t.string   "group",                  limit: 30
    t.string   "place",                  limit: 30
    t.datetime "start_at"
    t.string   "team1_placeholder_name", limit: 255
    t.string   "team2_placeholder_name", limit: 255
    t.boolean  "finished",               limit: 1,   default: false
    t.integer  "api_match_id",           limit: 4,                   null: false
  end

  add_index "games", ["api_match_id"], name: "index_games_on_api_match_id", using: :btree
  add_index "games", ["team1_id"], name: "index_games_on_team1_id", using: :btree
  add_index "games", ["team2_id"], name: "index_games_on_team2_id", using: :btree

  create_table "notices", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "text",         limit: 200
    t.datetime "deleted_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "lock_version", limit: 4,   default: 0
  end

  add_index "notices", ["user_id"], name: "index_notices_on_user_id", using: :btree

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message",    limit: 65535
    t.string   "username",   limit: 255
    t.integer  "item",       limit: 4
    t.string   "table",      limit: 255
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",         limit: 30
    t.datetime "deleted_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "lock_version", limit: 4,   default: 0
    t.string   "country_code", limit: 255
  end

  create_table "tips", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "game_id",      limit: 4
    t.integer  "tip_points",   limit: 4
    t.integer  "team1_goals",  limit: 4
    t.integer  "team2_goals",  limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "lock_version", limit: 4, default: 0
  end

  add_index "tips", ["game_id"], name: "index_tips_on_game_id", using: :btree
  add_index "tips", ["user_id"], name: "index_tips_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "firstname",              limit: 255
    t.string   "lastname",               limit: 255
    t.integer  "points",                 limit: 4
    t.integer  "count4points",           limit: 4
    t.integer  "count3points",           limit: 4
    t.integer  "count0points",           limit: 4
    t.integer  "championtippoints",      limit: 4
    t.integer  "championtip_team_id",    limit: 4
    t.datetime "deleted_at"
    t.integer  "lock_version",           limit: 4,   default: 0
    t.integer  "count5points",           limit: 4
    t.integer  "count8points",           limit: 4
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

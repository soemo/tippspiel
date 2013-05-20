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

ActiveRecord::Schema.define(:version => 20130520115106) do

  create_table "events", :force => true do |t|
    t.string   "event_type", :limit => 30, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "team1_id"
    t.integer  "team1_goals"
    t.integer  "team2_id"
    t.integer  "team2_goals"
    t.datetime "deleted_at"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.integer  "lock_version",                         :default => 0
    t.string   "round",                  :limit => 30
    t.string   "group",                  :limit => 30
    t.string   "place",                  :limit => 30
    t.datetime "start_at"
    t.string   "team1_placeholder_name"
    t.string   "team2_placeholder_name"
    t.boolean  "finished",                             :default => false
    t.integer  "api_match_id",                                            :null => false
  end

  add_index "games", ["api_match_id"], :name => "index_games_on_api_match_id"
  add_index "games", ["team1_id"], :name => "index_games_on_team1_id"
  add_index "games", ["team2_id"], :name => "index_games_on_team2_id"

  create_table "notices", :force => true do |t|
    t.integer  "user_id"
    t.string   "text",         :limit => 200
    t.datetime "deleted_at"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "lock_version",                :default => 0
  end

  add_index "notices", ["user_id"], :name => "index_notices_on_user_id"

  create_table "polls", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "lock_version", :default => 0
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "statistics", :force => true do |t|
    t.integer  "user_id"
    t.integer  "position"
    t.datetime "deleted_at"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "lock_version", :default => 0
    t.date     "date_on",                     :null => false
  end

  add_index "statistics", ["user_id"], :name => "index_statistics_on_user_id"

  create_table "teams", :force => true do |t|
    t.string   "flag_image_url"
    t.string   "name",           :limit => 30
    t.datetime "deleted_at"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "lock_version",                 :default => 0
  end

  create_table "tipps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "tipp_punkte"
    t.integer  "team1_goals"
    t.integer  "team2_goals"
    t.datetime "deleted_at"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "lock_version", :default => 0
  end

  add_index "tipps", ["game_id"], :name => "index_tipps_on_game_id"
  add_index "tipps", ["user_id"], :name => "index_tipps_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "points"
    t.integer  "count6points"
    t.integer  "count4points"
    t.integer  "count3points"
    t.integer  "count0points"
    t.integer  "championtipppoints"
    t.integer  "championtipp_team_id"
    t.integer  "poll_id"
    t.datetime "deleted_at"
    t.datetime "reset_password_sent_at"
    t.integer  "lock_version",                          :default => 0
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

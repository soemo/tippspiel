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

ActiveRecord::Schema.define(:version => 20111008133749) do

  create_table "days", :force => true do |t|
    t.date     "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0
  end

  create_table "games", :force => true do |t|
    t.integer  "group_id"
    t.integer  "place_id"
    t.integer  "round_id"
    t.integer  "day_id"
    t.integer  "starttime_id"
    t.integer  "team1_id"
    t.string   "team1_tore",   :limit => 2
    t.integer  "team2_id"
    t.string   "team2_tore",   :limit => 2
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",              :default => 0
  end

  create_table "groups", :force => true do |t|
    t.string   "name",         :limit => 30
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",               :default => 0
  end

  create_table "notices", :force => true do |t|
    t.integer  "user_id"
    t.string   "text",         :limit => 200
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                :default => 0
  end

  create_table "places", :force => true do |t|
    t.string   "name",         :limit => 30
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",               :default => 0
  end

  create_table "polls", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0
  end

  create_table "rounds", :force => true do |t|
    t.integer  "start_day_id"
    t.integer  "end_day_id"
    t.string   "name",         :limit => 30
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",               :default => 0
  end

  create_table "scheduler_runs", :force => true do |t|
    t.string   "schedule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "starttimes", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0
  end

  create_table "statistics", :force => true do |t|
    t.integer  "user_id"
    t.integer  "position"
    t.integer  "day_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", :default => 0
  end

  create_table "teams", :force => true do |t|
    t.string   "flag_image_url"
    t.string   "name",           :limit => 30
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                 :default => 0
  end

  create_table "tipps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "tipp_punkte"
    t.string   "team1_tore",   :limit => 2
    t.string   "team2_tore",   :limit => 2
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",              :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "points"
    t.integer  "good"
    t.integer  "count6points"
    t.integer  "count4points"
    t.integer  "count3points"
    t.integer  "count0points"
    t.integer  "championtipppoints"
    t.integer  "championtipp_team_id"
    t.integer  "poll_id"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_11_07_204345) do

  create_table "games", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "team1_id"
    t.integer "team1_goals"
    t.integer "team2_id"
    t.integer "team2_goals"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "lock_version", default: 0
    t.string "round", limit: 30
    t.string "group", limit: 30
    t.string "place", limit: 30
    t.datetime "start_at"
    t.string "team1_placeholder_name"
    t.string "team2_placeholder_name"
    t.boolean "finished", default: false
    t.index ["team1_id"], name: "index_games_on_team1_id"
    t.index ["team2_id"], name: "index_games_on_team2_id"
  end

  create_table "notices", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.string "text", limit: 200
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "lock_version", default: 0
    t.index ["user_id"], name: "index_notices_on_user_id"
  end

  create_table "teams", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "name", limit: 30
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "lock_version", default: 0
    t.string "country_code"
  end

  create_table "tips", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.integer "tip_points"
    t.integer "team1_goals"
    t.integer "team2_goals"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "lock_version", default: 0
    t.integer "ranking_place"
    t.index ["game_id"], name: "index_tips_on_game_id"
    t.index ["user_id"], name: "index_tips_on_user_id"
  end

  create_table "users", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "firstname"
    t.string "lastname"
    t.integer "points"
    t.integer "count4points"
    t.integer "count3points"
    t.integer "count0points"
    t.integer "bonus_points"
    t.integer "bonus_champion_team_id"
    t.datetime "deleted_at"
    t.integer "lock_version", default: 0
    t.integer "count5points"
    t.integer "count8points"
    t.boolean "create_initial_random_tips", default: false
    t.integer "bonus_second_team_id"
    t.integer "bonus_how_many_goals"
    t.integer "bonus_when_final_first_goal"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

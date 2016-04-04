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

ActiveRecord::Schema.define(version: 20160404020957) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.boolean  "finished",     default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "final_scores"
    t.text     "player_order"
  end

  create_table "games_teams", id: false, force: :cascade do |t|
    t.integer "game_id"
    t.integer "team_id"
  end

  add_index "games_teams", ["game_id", "team_id"], name: "games_teams_index", unique: true, using: :btree

  create_table "mprs", force: :cascade do |t|
    t.integer "player_id"
    t.integer "game_id"
    t.float   "mpr",       default: 0.0
  end

  add_index "mprs", ["game_id"], name: "index_mprs_on_game_id", using: :btree
  add_index "mprs", ["player_id"], name: "index_mprs_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players_teams", id: false, force: :cascade do |t|
    t.integer "player_id"
    t.integer "team_id"
  end

  add_index "players_teams", ["player_id", "team_id"], name: "players_teams_index", unique: true, using: :btree

  create_table "rounds", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "marks",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "rounds", ["game_id"], name: "index_rounds_on_game_id", using: :btree
  add_index "rounds", ["player_id"], name: "index_rounds_on_player_id", using: :btree
  add_index "rounds", ["team_id"], name: "index_rounds_on_team_id", using: :btree

  create_table "scores", force: :cascade do |t|
    t.integer  "points"
    t.integer  "multiplier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "round_id"
  end

  add_index "scores", ["round_id"], name: "index_scores_on_round_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "uid",                    default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "mprs", "games"
  add_foreign_key "mprs", "players"
  add_foreign_key "rounds", "games"
  add_foreign_key "rounds", "players"
  add_foreign_key "rounds", "teams"
  add_foreign_key "scores", "rounds"
end

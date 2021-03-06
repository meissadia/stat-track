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

ActiveRecord::Schema.define(version: 20151128124750) do

  create_table "db_settings", force: :cascade do |t|
    t.text     "user"
    t.text     "db_name"
    t.text     "db_user"
    t.text     "db_password"
    t.boolean  "start_fresh"
    t.boolean  "show_statements"
    t.boolean  "auto_populate_tables"
    t.boolean  "auto_populate_teams"
    t.boolean  "auto_populate_rosters"
    t.boolean  "auto_populate_schedules"
    t.boolean  "auto_populate_gamestats"
    t.boolean  "auto_populate_lotto"
    t.boolean  "auto_populate_draft"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "draft_picks", force: :cascade do |t|
    t.integer  "year"
    t.integer  "round"
    t.integer  "pick"
    t.string   "team_id"
    t.string   "pname"
    t.string   "college"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "abbr"
    t.integer  "game_num"
    t.boolean  "home"
    t.string   "opponent"
    t.integer  "opponent_id"
    t.boolean  "win",         default: false
    t.integer  "team_score"
    t.integer  "opp_score"
    t.datetime "datetime"
    t.boolean  "tv",          default: false
    t.integer  "boxscore_id", default: 0
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "season_type"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "games", ["abbr"], name: "index_games_on_abbr"
  add_index "games", ["boxscore_id"], name: "index_games_on_boxscore_id"
  add_index "games", ["team_id"], name: "index_games_on_team_id"

  create_table "gamestats", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "boxscore_id"
    t.string   "abbr"
    t.integer  "opponent_id"
    t.string   "opponent"
    t.integer  "game_num"
    t.string   "name"
    t.integer  "eid"
    t.string   "position"
    t.integer  "minutes"
    t.integer  "fgm"
    t.integer  "fga"
    t.integer  "tpm"
    t.integer  "tpa"
    t.integer  "ftm"
    t.integer  "fta"
    t.integer  "oreb"
    t.integer  "dreb"
    t.integer  "rebounds"
    t.integer  "assists"
    t.integer  "steals"
    t.integer  "blocks"
    t.integer  "turnovers"
    t.integer  "fouls"
    t.integer  "plusminus"
    t.integer  "points"
    t.boolean  "starter"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "gamestats", ["abbr"], name: "index_gamestats_on_abbr"
  add_index "gamestats", ["boxscore_id"], name: "index_gamestats_on_boxscore_id"
  add_index "gamestats", ["opponent"], name: "index_gamestats_on_opponent"
  add_index "gamestats", ["opponent_id"], name: "index_gamestats_on_opponent_id"
  add_index "gamestats", ["player_id"], name: "index_gamestats_on_player_id"

  create_table "lottos", force: :cascade do |t|
    t.integer  "rank"
    t.integer  "odds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "abbr"
    t.integer  "eid"
    t.string   "name"
    t.integer  "jersey"
    t.string   "position"
    t.integer  "age"
    t.integer  "height_ft"
    t.integer  "height_in"
    t.integer  "weight"
    t.string   "college"
    t.integer  "salary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "players", ["abbr"], name: "index_players_on_abbr"
  add_index "players", ["eid"], name: "index_players_on_eid"
  add_index "players", ["team_id"], name: "index_players_on_team_id"

  create_table "teams", force: :cascade do |t|
    t.string   "abbr"
    t.string   "name"
    t.string   "city"
    t.string   "division"
    t.string   "conference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teams", ["abbr"], name: "index_teams_on_abbr"

end

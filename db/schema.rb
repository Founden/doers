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

ActiveRecord::Schema.define(version: 20130414092640) do

  create_table "boards", force: true do |t|
    t.string   "title"
    t.integer  "position"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "panel_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boards", ["panel_id"], name: "index_boards_on_panel_id"
  add_index "boards", ["project_id"], name: "index_boards_on_project_id"
  add_index "boards", ["user_id"], name: "index_boards_on_user_id"

  create_table "fields", force: true do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.integer "board_id"
    t.integer "position"
    t.string  "type"
    t.text    "data"
  end

  add_index "fields", ["board_id"], name: "index_fields_on_board_id"
  add_index "fields", ["project_id"], name: "index_fields_on_project_id"
  add_index "fields", ["user_id"], name: "index_fields_on_user_id"

  create_table "identities", force: true do |t|
    t.string   "uid"
    t.string   "token"
    t.string   "account_type"
    t.integer  "account_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["uid"], name: "index_identities_on_uid"

  create_table "panels", force: true do |t|
    t.string   "label"
    t.integer  "position"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "panels", ["user_id"], name: "index_panels_on_user_id"

  create_table "projects", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email"

end

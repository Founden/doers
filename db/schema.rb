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

ActiveRecord::Schema.define(version: 20130624164233) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "assets", force: true do |t|
    t.integer  "project_id"
    t.integer  "board_id"
    t.integer  "user_id"
    t.text     "description"
    t.string   "type"
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "assets", ["assetable_id", "assetable_type"], name: "index_assets_on_assetable_id_and_assetable_type", using: :btree
  add_index "assets", ["board_id"], name: "index_assets_on_board_id", using: :btree
  add_index "assets", ["project_id"], name: "index_assets_on_project_id", using: :btree
  add_index "assets", ["type"], name: "index_assets_on_type", using: :btree
  add_index "assets", ["user_id"], name: "index_assets_on_user_id", using: :btree

  create_table "boards", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "author_id"
    t.integer  "project_id"
    t.integer  "parent_board_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boards", ["author_id"], name: "index_boards_on_author_id", using: :btree
  add_index "boards", ["parent_board_id"], name: "index_boards_on_parent_board_id", using: :btree
  add_index "boards", ["project_id"], name: "index_boards_on_project_id", using: :btree
  add_index "boards", ["status"], name: "index_boards_on_status", using: :btree
  add_index "boards", ["user_id"], name: "index_boards_on_user_id", using: :btree

  create_table "cards", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "board_id"
    t.integer  "position"
    t.string   "title"
    t.string   "type"
    t.text     "content"
    t.hstore   "data"
    t.string   "style"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cards", ["board_id"], name: "index_cards_on_board_id", using: :btree
  add_index "cards", ["position"], name: "index_cards_on_position", using: :btree
  add_index "cards", ["project_id"], name: "index_cards_on_project_id", using: :btree
  add_index "cards", ["type"], name: "index_cards_on_type", using: :btree
  add_index "cards", ["user_id"], name: "index_cards_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "parent_comment_id"
    t.integer  "project_id"
    t.integer  "board_id"
    t.integer  "user_id"
    t.text     "content"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["board_id"], name: "index_comments_on_board_id", using: :btree
  add_index "comments", ["parent_comment_id"], name: "index_comments_on_parent_comment_id", using: :btree
  add_index "comments", ["project_id"], name: "index_comments_on_project_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "identities", force: true do |t|
    t.string   "uid"
    t.string   "token"
    t.string   "account_type"
    t.integer  "account_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["uid"], name: "index_identities_on_uid", using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.string   "status"
    t.string   "website"
    t.hstore   "data"
    t.string   "external_id"
    t.string   "external_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["external_id", "external_type"], name: "index_projects_on_external_id_and_external_type", using: :btree
  add_index "projects", ["status"], name: "index_projects_on_status", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree
  add_index "projects", ["website"], name: "index_projects_on_website", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.hstore   "data"
    t.string   "external_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["external_id"], name: "index_users_on_external_id", using: :btree

end

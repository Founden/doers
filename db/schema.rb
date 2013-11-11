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

ActiveRecord::Schema.define(version: 20131101181144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: true do |t|
    t.string   "slug"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "board_id"
    t.integer  "card_id"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topic_id"
    t.integer  "comment_id"
    t.string   "type"
    t.integer  "whiteboard_id"
  end

  add_index "activities", ["board_id"], name: "index_activities_on_board_id", using: :btree
  add_index "activities", ["card_id"], name: "index_activities_on_card_id", using: :btree
  add_index "activities", ["comment_id"], name: "index_activities_on_comment_id", using: :btree
  add_index "activities", ["project_id"], name: "index_activities_on_project_id", using: :btree
  add_index "activities", ["slug"], name: "index_activities_on_slug", using: :btree
  add_index "activities", ["topic_id"], name: "index_activities_on_topic_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree
  add_index "activities", ["whiteboard_id"], name: "index_activities_on_whiteboard_id", using: :btree

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
    t.integer  "whiteboard_id"
  end

  add_index "assets", ["assetable_id", "assetable_type"], name: "index_assets_on_assetable_id_and_assetable_type", using: :btree
  add_index "assets", ["board_id"], name: "index_assets_on_board_id", using: :btree
  add_index "assets", ["project_id"], name: "index_assets_on_project_id", using: :btree
  add_index "assets", ["type"], name: "index_assets_on_type", using: :btree
  add_index "assets", ["user_id"], name: "index_assets_on_user_id", using: :btree
  add_index "assets", ["whiteboard_id"], name: "index_assets_on_whiteboard_id", using: :btree

  create_table "boards", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
    t.integer  "whiteboard_id"
  end

  add_index "boards", ["project_id"], name: "index_boards_on_project_id", using: :btree
  add_index "boards", ["status"], name: "index_boards_on_status", using: :btree
  add_index "boards", ["team_id"], name: "index_boards_on_team_id", using: :btree
  add_index "boards", ["user_id"], name: "index_boards_on_user_id", using: :btree
  add_index "boards", ["whiteboard_id"], name: "index_boards_on_whiteboard_id", using: :btree

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
    t.integer  "topic_id"
  end

  add_index "cards", ["board_id"], name: "index_cards_on_board_id", using: :btree
  add_index "cards", ["position"], name: "index_cards_on_position", using: :btree
  add_index "cards", ["project_id"], name: "index_cards_on_project_id", using: :btree
  add_index "cards", ["topic_id"], name: "index_cards_on_topic_id", using: :btree
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
    t.integer  "card_id"
    t.integer  "topic_id"
    t.integer  "whiteboard_id"
  end

  add_index "comments", ["board_id"], name: "index_comments_on_board_id", using: :btree
  add_index "comments", ["card_id"], name: "index_comments_on_card_id", using: :btree
  add_index "comments", ["parent_comment_id"], name: "index_comments_on_parent_comment_id", using: :btree
  add_index "comments", ["project_id"], name: "index_comments_on_project_id", using: :btree
  add_index "comments", ["topic_id"], name: "index_comments_on_topic_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree
  add_index "comments", ["whiteboard_id"], name: "index_comments_on_whiteboard_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",      default: 0, null: false
    t.integer  "attempts",      default: 0, null: false
    t.text     "handler",                   null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "membership_id"
  end

  add_index "delayed_jobs", ["membership_id"], name: "index_delayed_jobs_on_membership_id", using: :btree
  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "gutentag_taggings", force: true do |t|
    t.integer  "tag_id",        null: false
    t.integer  "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gutentag_taggings", ["tag_id"], name: "index_gutentag_taggings_on_tag_id", using: :btree
  add_index "gutentag_taggings", ["taggable_type", "taggable_id", "tag_id"], name: "unique_taggings", unique: true, using: :btree
  add_index "gutentag_taggings", ["taggable_type", "taggable_id"], name: "index_gutentag_taggings_on_taggable_type_and_taggable_id", using: :btree

  create_table "gutentag_tags", force: true do |t|
    t.string   "name",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "taggings_count", default: 0, null: false
  end

  add_index "gutentag_tags", ["name"], name: "index_gutentag_tags_on_name", unique: true, using: :btree
  add_index "gutentag_tags", ["taggings_count"], name: "index_gutentag_tags_on_taggings_count", using: :btree

  create_table "identities", force: true do |t|
    t.string   "token"
    t.string   "account_type"
    t.integer  "account_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid",          default: [], array: true
  end

  add_index "identities", ["uid"], name: "index_identities_on_uid", using: :gin

  create_table "invitations", force: true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.integer  "membership_id"
    t.string   "membership_type"
    t.integer  "invitable_id"
    t.string   "invitable_type"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["email"], name: "index_invitations_on_email", unique: true, using: :btree
  add_index "invitations", ["invitable_id", "invitable_type"], name: "index_invitations_on_invitable_id_and_invitable_type", using: :btree
  add_index "invitations", ["membership_id", "membership_type"], name: "index_invitations_on_membership_id_and_membership_type", using: :btree
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id", using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "creator_id"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "board_id"
    t.string   "type"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "whiteboard_id"
  end

  add_index "memberships", ["board_id"], name: "index_memberships_on_board_id", using: :btree
  add_index "memberships", ["creator_id"], name: "index_memberships_on_creator_id", using: :btree
  add_index "memberships", ["project_id"], name: "index_memberships_on_project_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree
  add_index "memberships", ["whiteboard_id"], name: "index_memberships_on_whiteboard_id", using: :btree

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

  create_table "teams", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "slug"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["slug"], name: "index_teams_on_slug", unique: true, using: :btree

  create_table "topics", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "board_id"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "whiteboard_id"
    t.integer  "aligned_card_id"
  end

  add_index "topics", ["aligned_card_id"], name: "index_topics_on_aligned_card_id", using: :btree
  add_index "topics", ["board_id"], name: "index_topics_on_board_id", using: :btree
  add_index "topics", ["position"], name: "index_topics_on_position", using: :btree
  add_index "topics", ["project_id"], name: "index_topics_on_project_id", using: :btree
  add_index "topics", ["user_id"], name: "index_topics_on_user_id", using: :btree
  add_index "topics", ["whiteboard_id"], name: "index_topics_on_whiteboard_id", using: :btree

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

  create_table "whiteboards", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "whiteboards", ["team_id"], name: "index_whiteboards_on_team_id", using: :btree
  add_index "whiteboards", ["user_id"], name: "index_whiteboards_on_user_id", using: :btree

end

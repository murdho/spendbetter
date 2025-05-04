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

ActiveRecord::Schema[8.1].define(version: 2025_05_04_161521) do
  create_table "entries", force: :cascade do |t|
    t.decimal "amount", null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.date "date"
    t.integer "entry_sync_id"
    t.string "external_id"
    t.integer "folder_id", null: false
    t.string "message"
    t.string "party"
    t.datetime "updated_at", null: false
    t.index ["entry_sync_id"], name: "index_entries_on_entry_sync_id"
    t.index ["external_id"], name: "index_entries_on_external_id", unique: true
    t.index ["folder_id"], name: "index_entries_on_folder_id"
  end

  create_table "entry_syncs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "folder_id", null: false
    t.json "raw_data"
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_entry_syncs_on_folder_id"
  end

  create_table "folders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "external_id"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_folders_on_external_id", unique: true
    t.index ["name"], name: "index_folders_on_name", unique: true
  end

  create_table "perspectives", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.boolean "pinned"
    t.text "query", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.datetime "access_expires_at", null: false
    t.string "access_token", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "refresh_expires_at", null: false
    t.string "refresh_token", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tokens_on_name", unique: true
  end

  add_foreign_key "entries", "entry_syncs"
  add_foreign_key "entries", "folders"
  add_foreign_key "entry_syncs", "folders"
end

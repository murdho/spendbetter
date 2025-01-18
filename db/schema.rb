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

ActiveRecord::Schema[8.1].define(version: 2025_01_18_061525) do
  create_table "entries", force: :cascade do |t|
    t.decimal "amount", null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.date "date"
    t.string "external_id"
    t.integer "folder_id", null: false
    t.string "message"
    t.string "party"
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_entries_on_folder_id"
  end

  create_table "folders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "entries", "folders"
end

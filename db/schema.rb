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

ActiveRecord::Schema[7.2].define(version: 2024_02_24_104324) do
  create_table "bank_transactions", force: :cascade do |t|
    t.date "date"
    t.integer "amount_cents", null: false
    t.string "currency", null: false
    t.string "party"
    t.string "description"
    t.integer "statement_id", null: false
    t.integer "category_id"
    t.integer "rule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_bank_transactions_on_category_id"
    t.index ["rule_id"], name: "index_bank_transactions_on_rule_id"
    t.index ["statement_id"], name: "index_bank_transactions_on_statement_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_type_id"], name: "index_categories_on_category_type_id"
  end

  create_table "category_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sort_order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_category_types_on_name", unique: true
  end

  create_table "rules", force: :cascade do |t|
    t.date "date"
    t.integer "amount_cents"
    t.string "currency"
    t.string "party"
    t.string "description"
    t.string "note"
    t.string "strictness", default: "lenient", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_rules_on_category_id"
    t.check_constraint "coalesce(date, amount_cents, currency, party, description) IS NOT NULL"
    t.check_constraint "strictness IN ('lenient', 'strict')"
  end

  create_table "statement_formats", force: :cascade do |t|
    t.string "label", null: false
    t.string "date_fmt", null: false
    t.string "date_col", null: false
    t.string "amount_col", null: false
    t.string "currency_col"
    t.string "party_col"
    t.string "description_col"
    t.string "default_currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label"], name: "index_statement_formats_on_label", unique: true
  end

  create_table "statements", force: :cascade do |t|
    t.string "filename", null: false
    t.integer "statement_format_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filename"], name: "index_statements_on_filename", unique: true
    t.index ["statement_format_id"], name: "index_statements_on_statement_format_id"
  end

  add_foreign_key "bank_transactions", "categories"
  add_foreign_key "bank_transactions", "rules"
  add_foreign_key "bank_transactions", "statements"
  add_foreign_key "categories", "category_types"
  add_foreign_key "rules", "categories"
  add_foreign_key "statements", "statement_formats"

  create_view "bank_transaction_matching_categories", sql_definition: <<-SQL
    SELECT bank_transactions.id AS bank_transaction_id,
           rules.id             AS rule_id,
           categories.id        AS category_id
    FROM bank_transactions
    LEFT JOIN rules ON (
            (rules.date IS NULL OR bank_transactions.date = rules.date)
        AND (rules.amount_cents IS NULL OR bank_transactions.amount_cents = rules.amount_cents)
        AND (rules.currency IS NULL OR bank_transactions.currency = rules.currency)
        AND (rules.party IS NULL
                OR (rules.strictness = 'strict' AND lower(bank_transactions.party) = lower(rules.party))
                OR (rules.strictness = 'lenient' AND bank_transactions.party LIKE '%' || rules.party || '%'))
        AND (rules.description IS NULL
                OR (rules.strictness = 'strict' AND lower(bank_transactions.description) = lower(rules.description))
                OR (rules.strictness = 'lenient' AND bank_transactions.description LIKE '%' || rules.description || '%'))
    )
    LEFT JOIN categories ON rules.category_id = categories.id
  SQL
end

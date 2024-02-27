class InitialSchema < ActiveRecord::Migration[7.2]
  def change
    create_table :statement_formats do |t|
      t.string :label, null: false, index: { unique: true }
      t.string :date_fmt, null: false
      t.string :date_col, null: false
      t.string :amount_col, null: false
      t.string :currency_col, null: false
      t.string :party_col
      t.string :description_col

      t.timestamps
    end

    create_table :statements do |t|
      t.string :filename, null: false, index: { unique: true }
      t.references :statement_format, null: false, foreign_key: true

      t.timestamps
    end

    create_table :category_types do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :sort_order

      t.timestamps
    end

    create_table :categories do |t|
      t.string :name, null: false
      t.references :category_type, foreign_key: true, index: true

      t.timestamps
    end

    create_table :rules do |t|
      t.date :date
      t.string :amount
      t.string :currency
      t.string :party
      t.string :description
      t.string :note
      t.string :strictness, null: false, default: "lenient"
      t.references :category, null: false, foreign_key: true, index: true

      t.timestamps

      t.check_constraint "strictness IN ('lenient', 'strict')"
      t.check_constraint "coalesce(date, amount, currency, party, description) IS NOT NULL"
    end

    create_table :bank_transactions do |t|
      t.date :date
      t.integer :amount_cents, null: false
      t.string :currency, null: false
      t.string :party
      t.string :description
      t.references :statement, null: false, foreign_key: true
      t.references :category, foreign_key: true, index: true
      t.references :rule, foreign_key: true, index: true

      t.timestamps
    end
  end
end

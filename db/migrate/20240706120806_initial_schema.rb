class InitialSchema < ActiveRecord::Migration[8.0]
  def change
    create_table :folders do |t|
      t.string :name, null: false, index: { unique: true }
      t.timestamps
    end

    create_table :journals do |t|
      t.string :import_stage, null: false
      t.references :folder, null: false, foreign_key: true
      t.timestamps
    end

    create_table :entries do |t|
      t.date :date
      t.decimal :amount, null: false
      t.string :currency
      t.string :party
      t.string :description
      t.references :journal, null: false, foreign_key: true
      t.timestamps
    end

    create_table :stickers do |t|
      t.string :name, null: false, index: { unique: true }
    end

    create_join_table :entries, :stickers do |t|
      t.index :entry_id
      t.index :sticker_id
    end
  end
end

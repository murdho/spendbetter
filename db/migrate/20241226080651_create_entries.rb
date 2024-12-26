class CreateEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :entries do |t|
      t.date :date
      t.decimal :amount, null: false
      t.string :currency, null: false
      t.string :party
      t.string :message
      t.string :external_id
      t.references :folder, null: false, foreign_key: true

      t.timestamps
    end
  end
end

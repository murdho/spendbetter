class CreatePerspectives < ActiveRecord::Migration[8.1]
  def change
    create_table :perspectives do |t|
      t.string :name
      t.text :query, null: false

      t.timestamps
    end
  end
end

class CreatePerspectives < ActiveRecord::Migration[8.1]
  def change
    create_table :perspectives do |t|
      t.text :query, null: false
      t.string :name
      t.boolean :pinned

      t.timestamps
    end
  end
end

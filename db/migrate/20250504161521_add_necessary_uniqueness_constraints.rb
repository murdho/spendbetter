class AddNecessaryUniquenessConstraints < ActiveRecord::Migration[8.1]
  def change
    add_index :folders, :name, unique: true
    add_index :folders, :external_id, unique: true

    add_index :entries, :external_id, unique: true
  end
end

class RemoveFolders < ActiveRecord::Migration[8.1]
  def change
    remove_reference :entries, :folder, null: false, foreign_key: true
    drop_table :folders
  end
end

class AddExternalIdToFolders < ActiveRecord::Migration[8.1]
  def change
    add_column :folders, :external_id, :text
  end
end

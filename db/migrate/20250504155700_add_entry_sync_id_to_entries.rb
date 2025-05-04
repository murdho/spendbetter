class AddEntrySyncIdToEntries < ActiveRecord::Migration[8.1]
  def change
    add_reference :entries, :entry_sync, foreign_key: true
  end
end

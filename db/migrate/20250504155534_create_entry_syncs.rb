class CreateEntrySyncs < ActiveRecord::Migration[8.1]
  def change
    create_table :entry_syncs do |t|
      t.references :folder, null: false, foreign_key: true
      t.json :metadata
      t.json :raw
      t.datetime :completed_at

      t.timestamps
    end
  end
end

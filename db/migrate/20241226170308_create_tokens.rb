class CreateTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :tokens do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.datetime :access_expires_at, null: false
      t.datetime :refresh_expires_at, null: false

      t.timestamps
    end
  end
end

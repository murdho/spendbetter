module Perspective::Database
  extend ActiveSupport::Concern

  DATABASE_PATH = Rails.root.join("storage", "perspective_database.duckdb").to_s

  class_methods do
    def refresh_database
      spendbetter_database_path = connection_db_config.database

      DuckDB::Database.open(DATABASE_PATH) do |duckdb|
        duckdb.connect do |conn|
          conn.query "DROP TABLE IF EXISTS entries"
          conn.query "ATTACH '#{spendbetter_database_path}' AS spendbetter (READ_ONLY, TYPE SQLITE)"
          conn.query "CREATE TABLE entries AS SELECT * FROM spendbetter.entries"
        end
      end
    end
  end
end

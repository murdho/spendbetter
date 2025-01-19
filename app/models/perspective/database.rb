class Perspective::Database
  DATABASE_PATH = Rails.root.join "storage", "perspective_database.#{Rails.env}.duckdb"

  class << self
    def refresh!
      DuckDB::Database.open path.to_s do |db|
        db.connect do |conn|
          conn.query "ATTACH '#{sqlite_database_path}' AS spendbetter (READ_ONLY, TYPE SQLITE)"
          conn.query "DROP TABLE IF EXISTS entries"
          conn.query "CREATE TABLE entries AS SELECT * FROM spendbetter.entries"
        end
      end
    end

    def path
      DATABASE_PATH
    end

    def updated_at
      path&.mtime
    end

    def exists?
      path.exist?
    end

    private
      def sqlite_database_path
        ApplicationRecord.connection_db_config.database
      end
  end
end

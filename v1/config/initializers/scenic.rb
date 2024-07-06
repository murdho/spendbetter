require "scenic_sqlite_adapter"

Scenic.configure do |config|
  config.database = ScenicSqlite::Adapter.new
end

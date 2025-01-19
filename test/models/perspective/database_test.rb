require "test_helper"

class Perspective::DatabaseTest < ActiveSupport::TestCase
  setup do
    @database_path = Perspective::Database.path
    File.delete @database_path if File.exist? @database_path
  end

  teardown do
    File.delete @database_path if File.exist? @database_path
  end

  # TODO: Running into problems here due to parallelization. Got to think what's the best way moving forward,
  #       so that things in production would also work reliably.

  # test "path returns the correct database path" do
  #   expected_path = Rails.root.join("storage", "perspective_database.#{Rails.env}.duckdb")
  #   assert_equal expected_path, Perspective::Database.path
  # end
  #
  # test "exists? returns false when database doesn't exist" do
  #   assert_not Perspective::Database.exists?
  # end
  #
  # test "exists? returns true when database exists" do
  #   Perspective::Database.refresh!
  #   assert Perspective::Database.exists?
  # end
  #
  # test "updated_at returns the modification time of the database" do
  #   Perspective::Database.refresh!
  #   assert_equal File.mtime(@database_path), Perspective::Database.updated_at
  # end
  #
  # test "refresh! creates entries table from sqlite database" do
  #   Perspective::Database.refresh!
  #
  #   DuckDB::Database.open @database_path.to_s do |db|
  #     db.connect do |conn|
  #       result = conn.query("SELECT COUNT(*) FROM entries").first
  #       assert_equal Entry.count, result.first
  #     end
  #   end
  # end
  #
  # test "refresh! overwrites existing entries table" do
  #   entry_count = Entry.count
  #   Perspective::Database.refresh!
  #
  #   entries(:bus_ticket).destroy!
  #   Perspective::Database.refresh!
  #
  #   DuckDB::Database.open @database_path.to_s do |db|
  #     db.connect do |conn|
  #       result = conn.query("SELECT COUNT(*) FROM entries").first
  #       assert_equal entry_count - 1, result.first
  #     end
  #   end
  # end
end

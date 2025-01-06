class DatabasesController < ApplicationController
  def show
    db_file = Rails.root.join("storage", "database.duckdb")
    etag = db_file.mtime.to_i
    fresh_when etag: etag

    send_file db_file, filename: "database.db"
  end
end

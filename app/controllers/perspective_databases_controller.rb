class PerspectiveDatabasesController < ApplicationController
  def show
    Perspective.database do
      it.refresh! unless it.exists?
      send_file it.path if stale? etag: it.updated_at
    end
  end
end

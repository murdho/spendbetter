class PerspectiveDatabasesController < ApplicationController
  def show
    Perspective.database do
      it.refresh! unless it.exists?
      fresh_when etag: it.updated_at
      send_file it.path if stale?
    end
  end
end

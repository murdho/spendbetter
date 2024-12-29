class Token < ApplicationRecord
  encrypts :access_token
  encrypts :refresh_token

  def fresh?
    Time.current < access_expires_at if access_token? && access_expires_at?
  end

  def refreshable?
    Time.current < refresh_expires_at if refresh_token? && refresh_expires_at?
  end

  def access_expires_in=(seconds)
    self.access_expires_at = Time.current + seconds.to_i
  end

  def refresh_expires_in=(seconds)
    self.refresh_expires_at = Time.current + seconds.to_i
  end
end

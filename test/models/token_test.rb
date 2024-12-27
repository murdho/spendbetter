require "test_helper"

class TokenTest < ActiveSupport::TestCase
  test "encryption" do
    assert_includes Token.encrypted_attributes, :access_token
    assert_includes Token.encrypted_attributes, :refresh_token
  end

  test "fresh?" do
    assert tokens(:fresh).fresh?
    assert_not tokens(:refreshable).fresh?
    assert_not tokens(:expired).fresh?
    assert_not Token.new.fresh?
  end

  test "refreshable?" do
    assert tokens(:fresh).refreshable?
    assert tokens(:refreshable).refreshable?
    assert_not tokens(:expired).refreshable?
    assert_not Token.new.refreshable?
  end

  test "access_expires_in=" do
    freeze_time
    token = Token.new access_expires_in: "3600"
    assert_equal Time.current + 1.hour, token.access_expires_at
  end

  test "refresh_expires_in=" do
    freeze_time
    token = Token.new refresh_expires_in: "3600"
    assert_equal Time.current + 1.hour, token.refresh_expires_at
  end
end

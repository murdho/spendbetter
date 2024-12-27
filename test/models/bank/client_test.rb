require "test_helper"
require "test_helpers/bank/client_request_stubs"

class Bank::ClientTest < ActiveSupport::TestCase
  include Bank::ClientRequestStubs

  def find_bank_client_token
    Token.find_sole_by name: Bank::Client::TOKEN_NAME
  end

  def create_bank_client_token(**attributes)
    Token.create! \
      attributes.with_defaults \
        name: Bank::Client::TOKEN_NAME,
        access_token: :bank_client_access_token,
        refresh_token: :bank_client_refresh_token,
        access_expires_at: Time.current + 1.hour,
        refresh_expires_at: Time.current + 1.day
  end

  test "with fresh token" do
    skip

    create_bank_client_token

    client = Bank::Client.new
    assert_equal "Bearer bank_client_access_token", client.authorization_header

    token = find_bank_client_token
    assert_equal "bank_client_access_token", token.access_token
    assert_equal "bank_client_refresh_token", token.refresh_token
    assert token.fresh?
  end

  test "with refreshable token" do
    skip

    create_bank_client_token access_expires_at: Time.current - 1.hour
    stub_refresh_api_token_request

    client = Bank::Client.new
    assert_equal "Bearer refreshed_access_token", client.authorization_header

    token = find_bank_client_token
    assert_equal "refreshed_access_token", token.access_token
    assert_equal "refreshed_refresh_token", token.refresh_token
    assert token.fresh?
  end

  test "with expired token" do
    skip

    create_bank_client_token \
      access_expires_at: Time.current - 1.hour,
      refresh_expires_at: Time.current - 1.hour
    stub_create_api_token_request

    client = Bank::Client.new
    assert_equal "Bearer brand_new_access_token", client.authorization_header

    token = find_bank_client_token
    assert_equal "brand_new_access_token", token.access_token
    assert_equal "brand_new_refresh_token", token.refresh_token
    assert token.fresh?
  end
end

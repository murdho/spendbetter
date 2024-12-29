require "test_helper"
require "test_helpers/bank_request_stubs"

class Bank::HttpTest < ActiveSupport::TestCase
  include BankRequestStubs

  test "with fresh token" do
    stub_request :get, Bank::Http::URL

    token = tokens(:fresh)
    Bank::Http.client(authorized_by: token.name).get

    assert_requested :get, Bank::Http::URL, headers: { Authorization: "Bearer fresh_access_token" }
    assert token.reload.fresh?
  end

  test "with refreshable token" do
    stub_request :get, Bank::Http::URL
    stub_refresh_api_token_request

    token = tokens(:refreshable)
    Bank::Http.client(authorized_by: token.name).get

    assert_requested :post, /token\/refresh/, body: { refresh: "fresh_refresh_token" }
    assert_requested :get, Bank::Http::URL, headers: { Authorization: "Bearer fresh_access_token" }
    assert token.reload.fresh?
  end

  test "with expired token" do
    stub_request :get, Bank::Http::URL
    stub_create_api_token_request

    token = tokens(:expired)
    Bank::Http.client(authorized_by: token.name).get

    assert_requested :post, /token\/new/, body: { secret_id: "fake_secret_id", secret_key: "fake_secret_key" }
    assert_requested :get, Bank::Http::URL, headers: { Authorization: "Bearer fresh_access_token" }
    assert token.reload.fresh?
  end
end

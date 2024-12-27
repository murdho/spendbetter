module Bank::ClientRequestStubs
  DEFAULT_REQUEST_HEADERS = {
    "Content-Type": "application/json",
    "User-Agent": "github.com/murdho/spendbetter"
  }

  DEFAULT_RESPONSE_HEADERS = {
    "Content-Type": "application/json"
  }

  def stub_create_api_token_request
    stub_request(:post, "https://bankaccountdata.gocardless.com/api/v2/token/new/")
      .with(
        headers: DEFAULT_REQUEST_HEADERS,
        body: { secret_id: "fake_secret_id", secret_key: "fake_secret_key" }
      )
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: {
          access: "brand_new_access_token",
          refresh: "brand_new_refresh_token",
          access_expires: "123",
          refresh_expires: "456"

        }.to_json
      )
  end

  def stub_refresh_api_token_request
    stub_request(:post, "#{Bank::Client::URL}token/refresh/")
      .with(
        headers: DEFAULT_REQUEST_HEADERS,
        body: { refresh: "bank_client_refresh_token" }
      )
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: {
          access: "refreshed_access_token",
          refresh: "refreshed_refresh_token",
          access_expires: "321",
          refresh_expires: "654"
        }.to_json
      )
  end
end

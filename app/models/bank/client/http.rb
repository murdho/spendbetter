module Bank::Client::Http
  extend ActiveSupport::Concern

  included do
    URL = "https://bankaccountdata.gocardless.com/api/v2/"
    USER_AGENT = "github.com/murdho/spendbetter"

    attr_reader :http_client
  end

  def authorization_header = http_client.headers["Authorization"]

  private

  def set_http_client
    @http_client = Faraday.new do |conn|
      conn.url_prefix = URL
      conn.headers = { "User-Agent": USER_AGENT }
      conn.request :json
      conn.response :json, parser_options: { symbolize_names: true }
      conn.response :raise_error
      conn.response :logger, Rails.logger if Rails.env.development?
    end
  end
end

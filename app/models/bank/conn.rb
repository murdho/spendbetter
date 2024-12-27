module Bank::Conn
  class TokenMiddleware < Faraday::Middleware
    def on_request(env)
      binding.irb
    end
  end

  URL = "https://bankaccountdata.gocardless.com/api/v2/"
  USER_AGENT = "github.com/murdho/spendbetter"

  def http_client
    @http_client ||= Faraday.new do |conn|
      conn.url_prefix = URL
      conn.headers = { "User-Agent": USER_AGENT }
      conn.request :json
      conn.response :json, parser_options: { symbolize_names: true }
      conn.response :raise_error
      conn.response :logger, Rails.logger do
        it.filter /(Authorization:\s+).*/, '\1[REDACTED]'
      end if Rails.env.development?

      conn.use TokenMiddleware
    end
  end
end

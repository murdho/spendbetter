module Bank::Http
  extend self

  URL = "https://bankaccountdata.gocardless.com/api/v2/"
  USER_AGENT = "github.com/murdho/spendbetter"

  # Create an HTTP client for communicating with the bank API.
  #
  # [<tt>authorized_by</tt>]
  #   Name for a Token for finding and storing API tokens. Optional.
  def client(authorized_by: nil)
    Faraday.new do |conn|
      conn.url_prefix = URL
      conn.headers = { "User-Agent": USER_AGENT }
      conn.request :json

      conn.use TokenAutoRefresh, token_name: authorized_by if authorized_by

      conn.response :json, parser_options: { decoder: [ Jason, :parse ] }
      conn.response :raise_error

      conn.response(:logger, Rails.logger, headers: true, bodies: true) { add_logging_filters it } if Rails.env.local?
    end
  end

  private
    def add_logging_filters(logger)
      logger.filter /(Authorization:\s+).*/, '\1[REDACTED]'
    end
end

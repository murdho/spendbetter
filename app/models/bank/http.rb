module Bank::Http
  extend self

  URL = "https://bankaccountdata.gocardless.com/api/v2/"
  USER_AGENT = "github.com/murdho/spendbetter"

  def client(authorized_by: nil)
    Faraday.new do |conn|
      conn.url_prefix = URL
      conn.headers = { "User-Agent": USER_AGENT }
      conn.request :json

      conn.use TokenAutoRefresh, token_name: authorized_by if authorized_by

      conn.response :json, parser_options: { decoder: [ JsonDecoder, :parse ] }
      conn.response :raise_error

      conn.response(:logger, Rails.logger) { add_logging_filters it } if Rails.env.development?
    end
  end

  private
    def add_logging_filters(logger)
      logger.filter /(Authorization:\s+).*/, '\1[REDACTED]'
    end
end

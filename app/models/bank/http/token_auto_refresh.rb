# Faraday middleware for automatically refreshing and storing both access and refresh tokens.
#
# ==== Options
#
# [<tt>token_name</tt>]
#   Specify name of the Token model record for finding and storing the API tokens.
#
# ==== Example
#
#   Faraday.new do |conn|
#     conn.use TokenAutoRefresh, token_name: :bla_bla
#   end
class Bank::Http::TokenAutoRefresh < Faraday::Middleware
  attr_reader :token

  def on_request(env)
    env.request_headers["Authorization"] = "Bearer #{access_token}"
  end

  private
    def access_token
      find_or_initialize_token
      refresh_or_create_token unless token.fresh?
      token.access_token
    end

    def find_or_initialize_token
      @token = Token.find_or_initialize_by name: options.fetch(:token_name)
    end

    def refresh_or_create_token
      token.with_lock do
        if token.refreshable?
          refresh_api_token
        else
          create_api_token
        end
      end
    end

    def refresh_api_token
      save_token \
        http_client
          .post("token/refresh/", { refresh: token.refresh_token })
          .body
    end

    def create_api_token
      save_token \
        http_client
          .post("token/new/", { secret_id:, secret_key: })
          .body
    end

    def save_token(new_tokens)
      new_tokens.values_at(:access, :refresh, :access_expires, :refresh_expires) \
        => access, refresh, access_expires, refresh_expires

      token.access_token = access if access
      token.refresh_token = refresh if refresh
      token.access_expires_in = access_expires if access_expires
      token.refresh_expires_in = refresh_expires if refresh_expires
      token.save!
    end

    def http_client
      @http_client ||= Bank::Http.client
    end

    def secret_id = Rails.configuration.spendbetter.gocardless.fetch(:secret_id)
    def secret_key = Rails.configuration.spendbetter.gocardless.fetch(:secret_key)
end

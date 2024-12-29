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

      unless token.fresh?
        token.with_lock do
          if token.refreshable?
            refresh_api_token
          else
            create_api_token
          end
        end
      end

      token.access_token
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
          .post("token/new/", {
            secret_id: Rails.configuration.spendbetter.gocardless.fetch(:secret_id),
            secret_key: Rails.configuration.spendbetter.gocardless.fetch(:secret_key)
          })
          .body
    end

    def save_token(new_tokens)
      new_tokens => { access:, refresh:, access_expires:, refresh_expires: }

      token.update!(
        access_token: access,
        refresh_token: refresh,
        access_expires_in: access_expires,
        refresh_expires_in: refresh_expires
      )
    end

    def find_or_initialize_token
      @token = Token.find_or_initialize_by name: options.fetch(:token_name)
    end

    def http_client
      @http_client ||= Bank::Http.client
    end
end

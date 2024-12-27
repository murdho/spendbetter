module Bank::Client::Token
  extend ActiveSupport::Concern

  included do
    TOKEN_NAME = :bank_client_token

    attr_reader :token
  end

  private
    def set_token
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

      http_client.headers["Authorization"] = "Bearer #{token.access_token}"
    end

    def find_or_initialize_token
      @token ||= Token.find_or_initialize_by name: TOKEN_NAME
    end

    def create_api_token
      save_token \
        http_client.post("token/new/", {
          secret_id: Rails.application.credentials.gocardless.secret_id,
          secret_key: Rails.application.credentials.gocardless.secret_key
        }).body
    end

    def refresh_api_token
      save_token \
        http_client.post("token/refresh/", { refresh: token.refresh_token }).body
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
end

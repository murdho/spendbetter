module Bank::Connection
  extend ActiveSupport::Concern

  DB_TOKEN_NAME = :bank_token

  included do
    delegate :connection, to: :class
  end

  class_methods do
    def connection
      @connection ||= Bank::Http.client authorized_by: DB_TOKEN_NAME
    end
  end
end

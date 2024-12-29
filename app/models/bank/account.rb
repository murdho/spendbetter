class Bank::Account
  include Bank::Connection

  attr_reader :id, :iban, :institution_id

  class << self
    def find(id)
      connection
        .get("accounts/#{id}/")
        .body
        .then { new(**it) }
    end
  end

  def initialize(id:, **attrs)
    @id = id
    @iban = attrs[:iban]
    @institution_id = attrs[:institution_id]
  end

  def balances
    @balances ||= \
      connection
        .get("accounts/#{id}/balances/")
        .body
        .dig(:balances)
  end

  def details
    @details ||= \
      connection
        .get("accounts/#{id}/details/")
        .body
        .dig(:account)
  end

  def transactions(from: nil, to: nil)
    if from || to
      fetch_transactions(from:, to:)
    else
      @transactions ||= fetch_transactions(from:, to:)
    end
  end

  private
    def fetch_transactions(from: nil, to: nil)
      connection
        .get("accounts/#{id}/transactions/", {
          date_from: format_date(from),
          date_to: format_date(to)
        }.compact)
        .body
        .dig(:transactions, :booked)
    end

    def format_date(date_or_datetime_or_string)
      date_or_datetime_or_string.try(:strftime, "%Y-%m-%d") || date_or_datetime_or_string
    end
end

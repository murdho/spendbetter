module StatementParser::TransactionNormalizer
  extend ActiveSupport::Concern

  def normalize_transaction(transaction)
    transaction
      .tap { normalize_date _1 }
      .tap { normalize_amount_and_currency _1 }
  end

  private

  def normalize_date(transaction)
    transaction[:date] = Date.strptime(transaction[:date], statement_format.date_fmt) rescue nil
  end

  def normalize_amount_and_currency(transaction)
    Monetize
      .parse(transaction.delete(:amount), transaction.delete(:currency))
      .then { transaction[:amount_cents], transaction[:currency] = _1.cents, _1.currency.iso_code }
  end
end

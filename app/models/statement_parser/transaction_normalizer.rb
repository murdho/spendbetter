module StatementParser::TransactionNormalizer
  extend ActiveSupport::Concern

  def normalize_transaction(transaction)
    transaction[:amount] = normalize_amount(transaction[:amount])
    transaction[:currency] = normalize_currency(transaction[:currency])
    transaction[:date] = normalize_date(transaction[:date])
    transaction
  end

  private

  def normalize_date(date)
    Date.strptime(date, statement_format.date_fmt) rescue nil
  end

  def normalize_currency(currency)
    currency&.upcase
  end

  def normalize_amount(amount)
    amount.tr(",", ".").then { BigDecimal(_1) }
  end
end

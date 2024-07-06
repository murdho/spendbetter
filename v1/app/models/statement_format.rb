class StatementFormat < ApplicationRecord
  include Parser, TransactionNormalizer

  has_many :statements

  normalizes :currency_col, :party_col, :payor_col, :payee_col, :description_col, :default_currency,
             with: ->(value) { value.presence }

  def column_mapping
    %i[date amount currency party payor payee description].to_h { [ _1, self["#{_1}_col"] ] }
  end
end

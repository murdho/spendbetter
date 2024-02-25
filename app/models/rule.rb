class Rule < ApplicationRecord
  belongs_to :category

  has_many :bank_transactions
end

class Rule < ApplicationRecord
  include Monetizable

  belongs_to :category

  has_many :bank_transactions
end

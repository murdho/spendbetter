class Category < ApplicationRecord
  has_many :bank_transactions
  has_many :rules
end

class Category < ApplicationRecord
  self.inheritance_column = nil

  has_many :bank_transactions
  has_many :rules
end

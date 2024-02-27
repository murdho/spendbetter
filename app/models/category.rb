class Category < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :category_type

  has_many :bank_transactions
  has_many :rules
end

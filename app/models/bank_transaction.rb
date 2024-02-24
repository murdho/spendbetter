class BankTransaction < ApplicationRecord
  belongs_to :statement
  belongs_to :category, optional: true
  belongs_to :rule, optional: true
end

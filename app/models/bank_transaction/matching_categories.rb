class BankTransaction::MatchingCategories < ApplicationRecord
  self.primary_key = :bank_transaction_id

  scope :with_category_id, -> { where.not(category_id: nil) }

  def readonly?
    true
  end
end

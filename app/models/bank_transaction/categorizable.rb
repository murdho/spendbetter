module BankTransaction::Categorizable
  extend ActiveSupport::Concern

  included do
    scope :categorized, -> { where.not(category_id: nil) }
    scope :uncategorized, -> { where(category_id: nil) }
  end

  class_methods do
    def categorize_all
      where("bank_transactions.id = matching_categories.bank_transaction_id")
        .update_all(<<~SQL.squish)
            rule_id = matching_categories.rule_id,
            category_id = matching_categories.category_id,
            updated_at = STRFTIME('%Y-%m-%d %H:%M:%f', 'NOW')
          FROM (#{BankTransaction::MatchingCategories.with_category_id.to_sql}) AS matching_categories
        SQL

      # FIXME: this is a hacky way to broadcast refresh, should be replaced
      # with something proper (or maybe get rid of the #update_all above?)
      BankTransaction.last.broadcast_refresh_to :overview
    end
  end
end

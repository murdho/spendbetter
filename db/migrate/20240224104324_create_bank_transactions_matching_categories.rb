class CreateBankTransactionsMatchingCategories < ActiveRecord::Migration[7.2]
  def change
    create_view :bank_transactions_matching_categories
  end
end

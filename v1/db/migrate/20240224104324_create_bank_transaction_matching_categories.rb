class CreateBankTransactionMatchingCategories < ActiveRecord::Migration[7.2]
  def change
    create_view :bank_transaction_matching_categories
  end
end

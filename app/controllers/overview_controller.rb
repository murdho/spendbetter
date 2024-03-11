class OverviewController < ApplicationController
  helper_method :selected_category_id

  def index
    @bank_transactions_for_summary = BankTransaction.for_summary
    @bank_transactions_for_details = BankTransaction.for_details(selected_category_id)
    @categories_for_select = Category.all
  end

  def selected_category_id
    params[:selected_category_id]
  end
end

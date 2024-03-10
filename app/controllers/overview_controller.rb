class OverviewController < ApplicationController
  helper_method :selected_category_id

  def index
    @bank_transactions_for_overview = BankTransaction.for_overview
    @bank_transactions_for_details = BankTransaction.for_details(selected_category_id)
  end

  def selected_category_id
    params[:selected_category_id]
  end
end

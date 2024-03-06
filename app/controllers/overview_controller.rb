class OverviewController < ApplicationController
  def index
    @bank_transactions_for_overview = BankTransaction.for_overview
    @bank_transactions_for_details = BankTransaction.for_details(selected_category_id)
  end

  private

  def selected_category_id
    # params[:category_id]
    nil
  end
end

class OverviewController < ApplicationController
  def index
    @bank_transactions_for_overview = BankTransaction.for_overview
    @bank_transactions_for_details = BankTransaction.for_details(detail_category_id)
  end

  private

  def detail_category_id
    params[:detail_category_id]
  end
end

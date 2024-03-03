class OverviewController < ApplicationController
  def index
    @bank_transactions = BankTransaction.for_overview
  end
end

require "test_helper"
require "test_helpers/bank_request_stubs"

class Bank::AccountTest < ActiveSupport::TestCase
  include BankRequestStubs

  setup do
    stub_token_requests

    @account = Bank::Account.new **SANDBOX_ACCOUNT_ONE
  end

  test "balances" do
    stub_account_balances_request SANDBOX_ACCOUNT_ONE, SANDBOX_ACCOUNT_ONE_BALANCES

    assert_equal SANDBOX_ACCOUNT_ONE_BALANCES, @account.balances
  end

  test "details" do
    stub_account_details_request SANDBOX_ACCOUNT_ONE, SANDBOX_ACCOUNT_ONE_DETAILS

    assert_equal SANDBOX_ACCOUNT_ONE_DETAILS, @account.details
  end

  test "transactions" do
    stub_account_transactions_request SANDBOX_ACCOUNT_ONE, SANDBOX_ACCOUNT_ONE_TRANSACTIONS

    assert_equal SANDBOX_ACCOUNT_ONE_TRANSACTIONS, @account.transactions
  end

  test "transactions from/to" do
    stub_account_transactions_request \
      SANDBOX_ACCOUNT_ONE, SANDBOX_ACCOUNT_ONE_TRANSACTIONS[1..], from: "2024-12-20", to: "2024-12-27"

    transactions = @account.transactions(from: "2024-12-20", to: "2024-12-27")
    assert_equal SANDBOX_ACCOUNT_ONE_TRANSACTIONS[1..], transactions
  end
end

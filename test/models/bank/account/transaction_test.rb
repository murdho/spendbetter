require "test_helper"
require "test_helpers/bank_request_stubs"

class Bank::Account::TransactionTest < ActiveSupport::TestCase
  include BankFixtures

  setup do
    Bank::Account.new(**SANDBOX_ACCOUNT_ONE).tap do |account|
      @debit = Bank::Account::Transaction.new account:, **SANDBOX_ACCOUNT_ONE_TRANSACTIONS.first
      @credit = Bank::Account::Transaction.new account:, **SANDBOX_ACCOUNT_ONE_TRANSACTIONS.last
    end
  end

  test "id" do
    assert_equal "68d5b037-0706-41b7-ad63-5e62df8684d9_fe956029a01f42f53e6ddec7058780f8", @debit.id
    assert_equal "68d5b037-0706-41b7-ad63-5e62df8684d9_7e369a9f8826501041598e5bd05aca38", @credit.id
  end

  test "amount" do
    assert_equal -95.35, @debit.amount
    assert_equal +15.00, @credit.amount
  end

  test "currency" do
    assert_equal "EUR", @debit.currency
    assert_equal "EUR", @credit.currency
  end

  test "date" do
    assert_equal "2024-12-28", @debit.date
    assert_equal "2024-12-27", @credit.date
  end

  test "message" do
    assert_equal "Freshto Ideal Clerkenwell", @debit.message
    assert_equal "Cab sharing, thank you!", @credit.message
  end

  test "party" do
    assert_equal "Freshto Ideal", @debit.party
    assert_equal "Jennifer Houston", @credit.party
  end

  test "debit?" do
    assert @debit.debit?
    assert_not @credit.debit?
  end

  test "credit?" do
    assert_not @debit.credit?
    assert @credit.credit?
  end
end

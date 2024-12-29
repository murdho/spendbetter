require "test_helper"
require "test_helpers/bank_request_stubs"

class BankTest < ActiveSupport::TestCase
  include BankRequestStubs

  setup do
    stub_token_requests
  end

  test "connect" do
    stub_create_agreement_request institution: SANDBOX_INSTITUTION
    stub_create_requisition_request institution: SANDBOX_INSTITUTION, agreement: SANDBOX_AGREEMENT

    requisition = Bank.connect Bank::Institution.new(**SANDBOX_INSTITUTION)
    assert_equal "780bcb92-c6cb-4cd8-9974-e0374177f7cd", requisition.id
    assert_equal "SANDBOXFINANCE_SFIN0000", requisition.institution_id
  end

  test "disconnect" do
    stub_delete_requisition_request SANDBOX_REQUISITION

    Bank.disconnect Bank::Requisition.new(**SANDBOX_REQUISITION)
    assert_requested :delete, /requisitions\/780bcb92-c6cb-4cd8-9974-e0374177f7cd/
  end

  test "countries" do
    assert_equal 30, Bank.countries.count
    assert_equal Bank::COUNTRIES, Bank.countries
  end

  test "institutions" do
    stub_institutions_request country: "XX"

    institutions = Bank.institutions country: "XX"
    assert_equal 1, institutions.count
    assert_equal "SANDBOXFINANCE_SFIN0000", institutions.first.id
  end

  test "institution" do
    stub_institution_request SANDBOX_INSTITUTION

    institution = Bank.institution SANDBOX_INSTITUTION_ID
    assert_equal "SANDBOXFINANCE_SFIN0000", institution.id
  end

  test "sandbox institution" do
    stub_institution_request SANDBOX_INSTITUTION

    institution = Bank.sandbox_institution
    assert_equal "SANDBOXFINANCE_SFIN0000", institution.id
    assert_equal 180, institution.max_access_valid_for_days
    assert_equal "Sandbox Finance", institution.name
    assert_equal 90, institution.transaction_total_days
  end

  test "requisitions" do
    stub_requisitions_request

    requisitions = Bank.requisitions
    assert_equal 1, requisitions.count

    requisitions.first.tap do
      assert_equal "780bcb92-c6cb-4cd8-9974-e0374177f7cd", it.id
      assert_equal "SANDBOXFINANCE_SFIN0000", it.institution_id
      assert_equal "be233689-b8b9-4c24-8b1f-9c4a7d522ea3", it.reference_id
      assert_match /ob.gocardless.com\/ob-psd2\/start\/.*\/SANDBOXFINANCE_SFIN0000/, it.link
      assert_equal %w[68d5b037-0706-41b7-ad63-5e62df8684d9 9daf5886-2d46-464b-9f2b-65accac9295e], it.account_ids
    end
  end

  test "accounts" do
    stub_accounts_request SANDBOX_REQUISITION, SANDBOX_ACCOUNT_ONE, SANDBOX_ACCOUNT_TWO

    accounts = Bank.accounts requisition_id: SANDBOX_REQUISITION_ID
    assert_equal 2, accounts.count

    assert_equal "68d5b037-0706-41b7-ad63-5e62df8684d9", accounts.first.id
    assert_equal "GL3510230000010234", accounts.first.iban
    assert_equal "SANDBOXFINANCE_SFIN0000", accounts.first.institution_id

    assert_equal "9daf5886-2d46-464b-9f2b-65accac9295e", accounts.last.id
    assert_equal "GL2981370000081378", accounts.last.iban
    assert_equal "SANDBOXFINANCE_SFIN0000", accounts.last.institution_id
  end

  test "account" do
    stub_account_request SANDBOX_ACCOUNT_ONE

    account = Bank.account SANDBOX_ACCOUNT_ONE_ID
    assert_equal "68d5b037-0706-41b7-ad63-5e62df8684d9", account.id
    assert_equal "GL3510230000010234", account.iban
    assert_equal "SANDBOXFINANCE_SFIN0000", account.institution_id
  end
end

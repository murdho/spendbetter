require "test_helpers/bank_fixtures"

module BankRequestStubs
  extend ActiveSupport::Concern

  include BankFixtures

  DEFAULT_RESPONSE_HEADERS = {
    "Content-Type": "application/json"
  }

  def stub_token_requests
    stub_refresh_api_token_request
    stub_create_api_token_request
  end

  def stub_refresh_api_token_request
    stub_request(:post, "#{Bank::Http::URL}token/refresh/")
      .with(body: { refresh: "fresh_refresh_token" })
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: {
          access: "fresh_access_token",
          access_expires: "321"
        }.to_json
      )
  end

  def stub_create_api_token_request
    stub_request(:post, "#{Bank::Http::URL}token/new/")
      .with(body: { secret_id: "fake_secret_id", secret_key: "fake_secret_key" })
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: {
          access: "fresh_access_token",
          refresh: "fresh_refresh_token",
          access_expires: "123",
          refresh_expires: "456"

        }.to_json
      )
  end

  def stub_institutions_request(country:)
    stub_request(:get, "#{Bank::Http::URL}institutions/")
      .with(query: { country: })
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: [ SANDBOX_INSTITUTION ].to_json
      )
  end

  def stub_institution_request(institution)
    stub_request(:get, "#{Bank::Http::URL}institutions/#{institution.fetch(:id)}/")
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: institution.to_json
      )
  end

  def stub_create_agreement_request(institution:)
    stub_request(:post, "#{Bank::Http::URL}agreements/enduser/")
      .with(
        body: {
          institution_id: institution.fetch(:id),
          max_historical_days: institution.fetch(:transaction_total_days).to_i,
          access_valid_for_days: institution.fetch(:max_access_valid_for_days).to_i,
          access_scope: %w[balances details transactions]
        }
      )
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: SANDBOX_AGREEMENT.to_json
      )
  end

  def stub_create_requisition_request(institution:, agreement:)
    stub_request(:post, "#{Bank::Http::URL}requisitions/")
      .with(
        body: {
          institution_id: institution.fetch(:id),
          agreement: agreement.fetch(:id),
          reference: /^\h{8}-(\h{4}-){3}\h{12}$/, # Any UUID
          redirect: "http://localhost:3000", # Placeholder value for now
          user_language: "EN"
        }
      )
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: SANDBOX_REQUISITION.to_json
      )
  end

  def stub_requisitions_request
    stub_request(:get, "#{Bank::Http::URL}requisitions/")
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: {
          count: 1,
          next: nil,
          previous: nil,
          results: [ SANDBOX_REQUISITION ]
        }.to_json
      )
  end

  def stub_accounts_request(requisition, *accounts)
    stub_requisition_request requisition
    accounts.each { stub_account_request it }
  end

  def stub_requisition_request(requisition)
    stub_request(:get, "#{Bank::Http::URL}requisitions/#{requisition.fetch(:id)}/")
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: requisition.to_json
      )
  end

  def stub_delete_requisition_request(requisition)
    stub_request(:delete, "#{Bank::Http::URL}requisitions/#{requisition.fetch(:id)}/")
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: {
          summary: "Requisition deleted",
          detail: "Requisition #{requisition.fetch(:id)} deleted with all its End User Agreements"
        }.to_json
      )
  end

  def stub_account_request(account)
    stub_request(:get, "#{Bank::Http::URL}accounts/#{account.fetch(:id)}/")
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: account.to_json
      )
  end

  def stub_account_balances_request(account, balances)
    stub_request(:get, "#{Bank::Http::URL}accounts/#{account.fetch(:id)}/balances/")
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: { balances: }.to_json
      )
  end

  def stub_account_details_request(account, details)
    stub_request(:get, "#{Bank::Http::URL}accounts/#{account.fetch(:id)}/details/")
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: { account: details }.to_json
      )
  end

  def stub_account_transactions_request(account, transactions, from: nil, to: nil)
    stub_request(:get, "#{Bank::Http::URL}accounts/#{account.fetch(:id)}/transactions/")
      .with(query: { date_from: from, date_to: to }.compact)
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: { transactions: { booked: transactions } }.to_json
      )
  end
end

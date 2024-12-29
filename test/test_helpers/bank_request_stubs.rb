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
          refresh: "fresh_refresh_token",
          access_expires: "321",
          refresh_expires: "654"
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

  def stub_account_request(account)
    stub_request(:get, "#{Bank::Http::URL}accounts/#{account.fetch(:id)}/")
      .to_return(
        status: 200,
        headers: DEFAULT_RESPONSE_HEADERS,
        body: account.to_json
      )
  end
end
class Bank::Client
  include Http, Token

  SANDBOX_INSTITUTION_ID = "SANDBOXFINANCE_SFIN0000"

  def initialize
    set_http_client
    set_token
  end

  def countries
    # https://gocardless.com/bank-account-data/coverage/
    #
    # `curl -sL https://docs.google.com/spreadsheets/d/1EZ5n7QDGaRIot5M86dwqd5UFSGEDTeTRzEq3D9uEDkM/export?format=csv`
    #   .then { CSV.parse it, headers: true }["Countries "]
    #   .filter { it&.length == 2 }
    #   .uniq
    #   .sort
    #   .join(" ")
    #   .then { puts "%w[#{it}]"}
    %w[AT BE BG CY CZ DE DK EE ES FI FR GB GR HR HU IE IS IT LT LU LV MT NL NO PL PT RO SE SI SK]
  end

  def institutions(country:)
    http_client
      .get("institutions/", { country: })
      .body
  end

  def institution(institution_id)
    http_client
      .get("institutions/#{institution_id}/")
      .body
  end

  def create_agreement(institution_id:,
                       max_historical_days: 180,
                       access_valid_for_days: 90,
                       access_scope: [ :balances, :details, :transactions ])
    http_client
      .post("agreements/enduser/", {
        institution_id:,
        max_historical_days:,
        access_valid_for_days:,
        access_scope:
      })
      .body
  end

  def create_requisition(spendbetter_id:,
                         institution_id:,
                         agreement_id:,
                         language: :EN,
                         redirect_url: "http://localhost:3000")
    http_client
      .post("requisitions/", {
        institution_id:,
        agreement: agreement_id,
        reference: spendbetter_id,
        redirect: redirect_url,
        user_language: language
      })
      .body
  end

  def requisition(requisition_id)
    http_client
      .get("requisitions/#{requisition_id}/")
      .body
  end

  def accounts(requisition_id)
    requisition(requisition_id) => { accounts: }
    accounts.map { |account_id| Bank::Account.new account_id }
  end

  def account_info(account_id)
    http_client
      .get("accounts/#{account_id}/")
      .body
  end

  def account_balances(account_id)
    http_client
      .get("accounts/#{account_id}/balances/")
      .body
  end

  def account_details(account_id)
    http_client
      .get("accounts/#{account_id}/details/")
      .body
  end

  def account_transactions(account_id, from: nil, to: nil)
    http_client
      .get("accounts/#{account_id}/transactions/", {
        date_from: format_date(from),
        date_to: format_date(to)
      }.compact)
      .body
  end

  private
    def format_date(date_or_datetime_or_string)
      date_or_datetime_or_string.try(:strftime, "%Y-%m-%d") || date_or_datetime_or_string
    end
end

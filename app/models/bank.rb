module Bank
  extend self

  SANDBOX_INSTITUTION_ID = "SANDBOXFINANCE_SFIN0000"

  # https://gocardless.com/bank-account-data/coverage/
  #
  # `curl -sL https://docs.google.com/spreadsheets/d/1EZ5n7QDGaRIot5M86dwqd5UFSGEDTeTRzEq3D9uEDkM/export?format=csv`
  #   .then { CSV.parse it, headers: true }["Countries "]
  #   .filter { it&.length == 2 }
  #   .uniq
  #   .sort
  #   .join(" ")
  #   .then { puts "%w[#{it}]"}
  COUNTRIES = %w[AT BE BG CY CZ DE DK EE ES FI FR GB GR HR HU IE IS IT LT LU LV MT NL NO PL PT RO SE SI SK]

  def connect(institution, **opts)
    Bank::Requisition.create institution, **opts
  end

  def disconnect(requisition)
    requisition.delete
  end

  def countries
    COUNTRIES
  end

  def institutions(country:)
    Bank::Institution.find_by_country country
  end

  def institution(id)
    Bank::Institution.find id
  end

  def sandbox_institution
    Bank::Institution.find SANDBOX_INSTITUTION_ID
  end

  def requisitions
    Bank::Requisition.all
  end

  def accounts(requisition_id:)
    Bank::Requisition.find(requisition_id).accounts
  end

  def account(id)
    Bank::Account.find id
  end
end

module BankFixtures
  SANDBOX_INSTITUTION = {
    id: "SANDBOXFINANCE_SFIN0000",
    name: "Sandbox Finance",
    bic: "SFIN0000",
    transaction_total_days: "90",
    countries: [ "XX" ],
    logo: "https://cdn-logos.gocardless.com/ais/SANDBOXFINANCE_SFIN0000.png",
    max_access_valid_for_days: "180",
    supported_payments: {},
    supported_features: [],
    identification_codes: []
  }

  SANDBOX_INSTITUTION_ID = Bank::SANDBOX_INSTITUTION_ID

  SANDBOX_REQUISITION = {
    id: "780bcb92-c6cb-4cd8-9974-e0374177f7cd",
    created: "2024-12-27T21:34:20.658531Z",
    redirect: "http://localhost:3000",
    status: "LN",
    institution_id: "SANDBOXFINANCE_SFIN0000",
    agreement: "bdaade38-3b03-4857-9ed9-4a33ce20da45",
    reference: "be233689-b8b9-4c24-8b1f-9c4a7d522ea3",
    accounts: [ "68d5b037-0706-41b7-ad63-5e62df8684d9", "9daf5886-2d46-464b-9f2b-65accac9295e" ],
    user_language: "EN",
    link: "https://ob.gocardless.com/ob-psd2/start/15321acf-7c3f-49d2-b19c-b8f749d91d7d/SANDBOXFINANCE_SFIN0000",
    ssn: nil,
    account_selection: false,
    redirect_immediate: false
  }

  SANDBOX_REQUISITION_ID = SANDBOX_REQUISITION.fetch(:id)

  SANDBOX_ACCOUNT_ONE = {
    id: "68d5b037-0706-41b7-ad63-5e62df8684d9",
    created: "2024-01-07T17:20:30.855119Z",
    last_accessed: "2024-12-27T21:38:15.277931Z",
    iban: "GL3510230000010234",
    institution_id: "SANDBOXFINANCE_SFIN0000",
    status: "READY",
    owner_name: "John Doe",
    bban: nil
  }

  SANDBOX_ACCOUNT_ONE_ID = SANDBOX_ACCOUNT_ONE.fetch(:id)

  SANDBOX_ACCOUNT_ONE_BALANCES = [
    {
      balance_amount: { amount: "1913.12", currency: "EUR" },
      balance_type: "expected", reference_date: "2024-12-29"
    },
    {
      balance_amount: { amount: "1913.12", currency: "EUR" },
      balance_type: "interimAvailable", reference_date: "2024-12-29"
    }
  ]

  SANDBOX_ACCOUNT_ONE_DETAILS = {
    resource_id: "01F3NS4YV94RA29YCH8R0F6BMF",
    iban: "GL3510230000010234",
    currency: "EUR",
    owner_name: "John Doe",
    name: "Main Account",
    product: "Checkings",
    cash_account_type: "CACC"
  }

  SANDBOX_ACCOUNT_ONE_TRANSACTIONS = [
    {
      transaction_id: "2024122801773517-1",
      entry_reference: "2024122801773517-1",
      booking_date: "2024-12-28",
      value_date: "2024-12-28",
      transaction_amount: { amount: "-95.35", currency: "EUR" },
      creditor_name: "Freshto Ideal",
      remittance_information_unstructured: "Freshto Ideal Clerkenwell",
      bank_transaction_code: "PMNT",
      proprietary_bank_transaction_code: "PURCHASE",
      internal_transaction_id: "fe956029a01f42f53e6ddec7058780f8"
    },
    {
      transaction_id: "2024122801773516-1",
      entry_reference: "2024122801773516-1",
      booking_date: "2024-12-27",
      value_date: "2024-12-27",
      transaction_amount: { amount: "15.00", currency: "EUR" },
      debtor_name: "Jennifer Houston",
      debtor_account: { iban: "IE96BOFI900017816198" },
      remittance_information_unstructured: "Cab sharing, thank you!",
      bank_transaction_code: "PMNT",
      proprietary_bank_transaction_code: "TRANSFER",
      internal_transaction_id: "7e369a9f8826501041598e5bd05aca38"
    }
  ]

  SANDBOX_ACCOUNT_TWO = {
    id: "9daf5886-2d46-464b-9f2b-65accac9295e",
    created: "2024-12-27T21:34:42.396133Z",
    last_accessed: nil,
    iban: "GL2981370000081378",
    institution_id: "SANDBOXFINANCE_SFIN0000",
    status: "READY",
    owner_name: "Jane Doe",
    bban: nil
  }

  SANDBOX_ACCOUNT_TWO_ID = SANDBOX_ACCOUNT_TWO.fetch(:id)
end

class Bank::Account::Transaction
  attr_reader :amount, :currency, :message

  def initialize(account:, internal_transaction_id:, transaction_amount:, **attrs)
    @account = account
    @internal_transaction_id = internal_transaction_id
    @amount = transaction_amount[:amount].to_d
    @currency = transaction_amount[:currency]
    @booking_date = attrs[:booking_date]
    @value_date = attrs[:value_date]
    @message = attrs[:remittance_information_unstructured]
    @creditor_name = attrs[:creditor_name]
    @debtor_name = attrs[:debtor_name]
  end

  def id = "#{account.id}_#{internal_transaction_id}"
  def date = booking_date || value_date
  def party = debit? ? creditor_name : debtor_name

  def debit? = amount.negative?
  def credit? = amount.positive?

  def ==(other)= other.is_a?(self.class) && id == other.id

  private
    attr_reader :account, :internal_transaction_id, :booking_date, :value_date, :creditor_name, :debtor_name
end

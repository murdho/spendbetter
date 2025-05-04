class EntrySync < ApplicationRecord
  belongs_to :folder

  FIRST_SYNC_FROM = -> { 1.year.ago }

  def sync_entries
    assert folder.external_id, "cannot sync entries for folder #{folder.id} without external_id"
    assert completed_at.nil?

    with_lock do
      last_sync_at = folder.last_sync_at || FIRST_SYNC_FROM.call
      self.metadata[:last_sync_at] = last_sync_at
      save!

      account = Bank.account folder.external_id
      transactions = account.transactions from: last_sync_at
      self.raw = transactions
      save!

      transactions.each do |tx|
        tx_external_id = tx.fetch(:internal_transaction_id)
        assert tx_external_id.present?, "external_id missing for transaction #{tx} (folder #{id})"

        # https://bankaccountdata.zendesk.com/hc/en-gb/articles/11529646897820-internalTransactionId-a-unique-transaction-ID-now-generated-by-GoCardless
        unique_tx_external_id = "#{account.id}_#{tx_external_id}"
        entry = entries.find_or_initialize_by(external_id: unique_tx_external_id)

        amount = tx.dig(:transaction_amount, :amount).to_d
        entry.amount = amount
        entry.currency = tx.dig(:transaction_amount, :currency)
        entry.date = tx[:booking_date] || tx[:value_date]
        entry.message = tx[:remittance_information_unstructured]
        entry.party = amount.positive? ? tx[:creditor_name] : tx[:debtor_name]
        entry.entry_sync_id = entry_sync.id
        entry.save!
      end
    end
  end
end

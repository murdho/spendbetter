class Statement < ApplicationRecord
  include FileImportable

  belongs_to :statement_format

  has_many :bank_transactions, dependent: :destroy

  scope :for_views, -> { joins(:statement_format)
                           .left_joins(:bank_transactions)
                           .select("statements.*, statement_formats.label AS statement_format_label, count(bank_transactions.id) AS bank_transactions_count")
                           .group(:id)
                           .order(created_at: :desc) }
end

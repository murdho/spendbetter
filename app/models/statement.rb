class Statement < ApplicationRecord
  include FileImportable

  belongs_to :statement_format

  has_many :bank_transactions, dependent: :destroy
end

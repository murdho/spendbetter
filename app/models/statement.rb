class Statement < ApplicationRecord
  include FileImportable

  belongs_to :statement_format
end

class Folder < ApplicationRecord
  has_many :entries, dependent: :destroy
end

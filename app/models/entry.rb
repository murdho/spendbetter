class Entry < ApplicationRecord
  belongs_to :folder
  belongs_to :entry_sync
end

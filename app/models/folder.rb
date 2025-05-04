class Folder < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :entry_syncs, dependent: :destroy

  def last_sync_at
    entry_syncs.maximum :completed_at
  end
end

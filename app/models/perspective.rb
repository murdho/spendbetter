class Perspective < ApplicationRecord
  scope :named, -> { where.not name: [ nil, "" ] }
  scope :unnamed, -> { named.invert_where }
  scope :saved, -> { named }
  scope :recent, -> { unnamed.where updated_at: 7.days.ago.. }
end

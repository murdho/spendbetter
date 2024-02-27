class BankTransaction < ApplicationRecord
  include Categorizable, Monetizable

  belongs_to :statement
  belongs_to :category, optional: true
  belongs_to :rule, optional: true

  scope :with_count, -> { select("count(*) AS count") }
  scope :with_outgoing, -> { select("coalesce(sum(amount) FILTER (WHERE amount < 0), 0) AS outgoing") }
  scope :with_incoming, -> { select("coalesce(sum(amount) FILTER (WHERE amount > 0), 0) AS incoming") }
  scope :with_total, -> { select("sum(amount) AS total") }
  scope :with_month, -> { select("strftime('%Y-%m', date) AS month") }
  scope :with_category_name_and_type, -> { left_joins(category: :category_type)
                                             .select("categories.id": :category_id,
                                                     "categories.name": :category_name,
                                                     "category_types.name": :category_type) }

  scope :by_month, -> { with_month.group("month").order("month DESC") }
  scope :by_category, -> { with_category_name_and_type.group("categories.id").order("category_types.sort_order") }

  scope :for_month, ->(month) { with_month.where("month = ?", month) }
end

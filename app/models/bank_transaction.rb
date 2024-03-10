class BankTransaction < ApplicationRecord
  include Categorizable, Monetizable

  belongs_to :statement
  belongs_to :category, optional: true
  belongs_to :rule, optional: true

  scope :with_count, -> { select("count(*) AS count") }
  scope :with_outgoing, -> { select("coalesce(sum(amount_cents) FILTER (WHERE amount_cents < 0), 0) AS outgoing_cents") }
  scope :with_incoming, -> { select("coalesce(sum(amount_cents) FILTER (WHERE amount_cents > 0), 0) AS incoming_cents") }
  scope :with_total, -> { select("sum(amount_cents) AS total_cents") }
  scope :with_month, -> { select("strftime('%Y-%m', coalesce(date, date())) AS month") }
  scope :with_category_name_and_type, -> { left_joins(category: :category_type)
                                             .select("categories.id": :category_id,
                                                     "categories.name": :category_name,
                                                     "category_types.name": :category_type) }

  scope :by_month, -> { with_month.group("month").order("month DESC") }
  scope :by_category, -> { with_category_name_and_type.group("categories.id").order("category_types.sort_order") }
  scope :by_currency, -> { select(:currency).group(:currency) }

  scope :for_month, ->(month) { with_month.where("month = ?", month) }

  def self.for_overview
    all
      .by_month
      .by_category
      .by_currency
      .with_count
      .with_incoming
      .with_outgoing
      .with_total
      .group_by(&:month)
      .transform_values { _1.group_by(&:category_type) }
  end

  def self.for_details(category_id)
    all
      .left_joins(:category)
      .where(category_id: category_id)
      .with_month
      .order(:date)
      .select("bank_transactions.*, categories.name AS category_name")
      .group_by(&:month)
  end
end

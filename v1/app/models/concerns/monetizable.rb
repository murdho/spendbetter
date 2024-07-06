module Monetizable
  extend ActiveSupport::Concern

  AMOUNT_CENTS = :amount_cents

  included do
    monetize AMOUNT_CENTS, with_model_currency: :currency, allow_nil: amount_optional?
  end

  class_methods do
    def amount_optional? = column_for_attribute(AMOUNT_CENTS).null
  end

  def as_money(attribute) = Money.new(attributes[attribute.to_s], currency)
end

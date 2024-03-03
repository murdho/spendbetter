module OverviewHelper
  def money(money)
    humanized_money money, no_cents_if_whole: false
  end

  def money_color_class(amount_cents, positive_class, negative_class, zero_class)
    case
    when amount_cents > 0 then positive_class
    when amount_cents < 0 then negative_class
    else zero_class
    end
  end
end

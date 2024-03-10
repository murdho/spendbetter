module OverviewHelper
  def month_tag(month)
    Date.parse("#{month}-01").strftime("%B %Y")
  end

  def money_tag(money)
    humanized_money money, no_cents_if_whole: false
  end

  def money_color(amount_cents, positive, negative, zero)
    case
    when amount_cents > 0 then positive
    when amount_cents < 0 then negative
    else zero
    end
  end

  def link_to_select_category(name, id)
    link_to (name || "—"), { selected_category_id: id }, "data-turbo-action": :replace
  end
end

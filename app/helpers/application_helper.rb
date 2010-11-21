module ApplicationHelper
  def amount_dollars(amount_cents)
    amount_cents.to_f / 100
  end
  
  def money(amount_cents)
    number_to_currency(amount_dollars(amount_cents))
  end
  
  def money_no_unit(amount_cents)
    number_to_currency(amount_dollars(amount_cents), :format => '%n')
  end
end

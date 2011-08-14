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
  
  def money_no_unit_no_zero(amount_cents)
    amount_cents == 0 ? '' : money_no_unit(amount_cents)
  end

  def random_group_name
    (NOUNS[rand(NOUNS.size)] + '-' + ADJECTIVES[rand(ADJECTIVES.size)]).gsub("_","-")
  end
end

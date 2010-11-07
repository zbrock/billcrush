module ApplicationHelper
  def money(amount_cents)
    number_to_currency(amount_cents.to_f / 100)
  end
end

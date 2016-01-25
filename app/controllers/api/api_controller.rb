class Api::ApiController < ActionController::Base
  def amount_cents(amount_decimal)
    (amount_decimal.to_f * 100).round
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def amount_cents(amount_decimal)
    (amount_decimal.to_f * 100).round.to_i
  end

  private
  def load_group
    if params[:name].present?
      @group = Group.find_by_canonicalized_name!(params[:name])
    elsif params[:group_id].present?
      @group = Group.find_by_canonicalized_name!(params[:group_id])
    else
      @group = Group.find(params[:id])
    end
  end
end

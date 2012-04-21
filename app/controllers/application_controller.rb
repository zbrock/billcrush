class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, :with => :render_404
  rescue_from ActionController::UnknownAction, :with => :render_404
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  protect_from_forgery
  
  def amount_cents(amount_decimal)
    (amount_decimal.to_f * 100).round
  end

  def render_404
    if /(jpe?g|png|gif)/i === request.path
      render :text => "404 Not Found", :status => 404
    else
      render :template => "shared/404", :layout => 'application', :status => 404
    end
  end

  private
  def load_group
    if params[:name].present?
      @group = Group.find_by_canonicalized_name!(params[:name])
    elsif params[:group_id].present?
      @group = Group.find_by_canonicalized_name!(params[:group_id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end

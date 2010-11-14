class ApplicationController < ActionController::Base
  protect_from_forgery

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

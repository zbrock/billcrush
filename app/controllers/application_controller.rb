class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def load_group
    @group = Group.find(params[:group_id])
  end
end

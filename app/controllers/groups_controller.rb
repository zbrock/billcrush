class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      cookies[:show_help] = true
      redirect_to(group_settings_url(@group))
    else
      flash[:error] = "Bad group name"
      redirect_to new_group_url
    end
  end

  def show
    redirect_to(group_url(@group)) if request.env['REQUEST_URI'] =~ /\?$/
    load_group
    if cookies[:show_help].present?
      flash.now[:message] = "Don't forget your url! It's the only way to access your group."
      cookies[:show_help] = nil
    end
    @members = @group.members
    @transactions = @group.transactions.scoped_by_active(true)
    @new_transaction = @group.transactions.build
    # get rid of the new ones
    @members.reload
    @transactions.reload
  end
  
  def settings
    load_group
    @members = @group.members
    @new_member = @group.members.build
    # get rid of the new ones
    @members.reload
  end
end

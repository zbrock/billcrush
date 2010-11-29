class GroupsController < ApplicationController
  def index
    @groups = Group.all  
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      redirect_to group_url(@group)
    else
      flash[:error] = "Bad group info"
      redirect_to new_group_url
    end
  end

  def show
    load_group
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

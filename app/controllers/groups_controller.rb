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
    @group = Group.find(params[:id])
    @members = @group.members
    @transactions = @group.transactions
    @new_member = @group.members.build
    @new_transaction = @group.transactions.build
    # get rid of the new ones
    @members.reload
    @transactions.reload
  end
end
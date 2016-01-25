class Api::GroupsController < Api::ApiController
  def show
    @group = Group.find_by_canonicalized_name!(params[:id])
    render :json => @group.to_json({:include => [:members, :transactions]})
  end
end

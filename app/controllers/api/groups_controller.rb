class Api::GroupsController < Api::ApiController
  def show
    @group = Group.find_by_canonicalized_name!(params[:name])
    render :json => @group.to_json({:include => [:members, :transactions]})
  end
end

require 'spec_helper'

describe MembersController do
  before { @group = Factory(:group) }
  describe "#create" do
    context "with valid params" do
      before { @params = {:group_id => @group.to_param, :member => {:name => "Bob"}} }

      it "changes the member count by 1" do
        expect { post :create, @params }.to change(Member, :count).by(1)
      end

      it "redirects to the group settings page" do
        post :create, @params
        group = assigns[:group]
        response.should redirect_to(group_settings_url(group))
        flash[:message].should_not be_blank
      end
    end

    context "with invalid params" do
      before { @params = {:group_id => @group.to_param, :member => {:name => ""}} }

      it "changes the member count by 0" do
        expect { post :create, @params }.to_not change(Member, :count)
      end

      it "redirects to the group settings page" do
        post :create, @params
        group = assigns[:group]
        response.should redirect_to(group_settings_url(group))
        flash[:error].should_not be_blank
      end
    end
  end
end

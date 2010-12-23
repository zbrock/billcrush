require 'spec_helper'

describe GroupsController do
  render_views

  describe "#show" do
    context "with a group name" do
      it "routes to the correct group" do
        group = Factory(:group, :name => "foobar")
        get :show, :name => "foobar"
        assigns[:group].should == group
      end

      it "throws a 404 if the group can't be found" do
        expect { get :show, :name => "jibberjabber" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#create" do
    context "with a valid name" do
      before { @params = {:group => {:name => "foobar"}} }
      it "changes the group count by 1" do
        expect { post :create, @params }.to change(Group, :count).by(1)
      end
      it "redirects to the new group's settings page" do
        post :create, @params
        group = assigns[:group]
        response.should redirect_to(group_settings_url(group))
      end
      it "doesn't store a password if none is specified" do
        post :create, @params
        group = assigns[:group]
        group.password_hash.should be_nil
      end

      it "stores a password if one is specified" do
        post :create, @params.merge(:group => {:password => "fizzle"})
        group = assigns[:group]
        group.password_hash.should be_present
      end

    end
    context "with an invalid name" do
      before { @params = {:group => {:name => ""}} }

      it "doesn't change the group count" do
        expect { post :create, @params }.to_not change(Group, :count)
      end

      it "flashes an error message and redirects to new" do
        post :create, @params
        flash[:error].should_not be_empty
        response.should redirect_to(new_group_url)
      end
    end
  end
end

require 'spec_helper'

describe GroupsController, type: :controller do
  render_views

  describe "#show" do
    context "with a group name" do
      it "routes to the correct group" do
        group = Factory(:group, :name => "foobar")
        get :show, :name => "foobar"
        expect(assigns[:group]).to eq(group)
      end
      
      it "doesn't allow access by id" do
        group = Factory(:group, :name => "foobar")
        get :show, :id => group.id
        expect(response.status).to eq(404)
      end

      it "throws a 404 if the group can't be found" do
        get :show, :name => "jibberjabber"
        expect(response.status).to eq(404)
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
        expect(response).to redirect_to(group_settings_url(group))
      end
    end
    context "with an invalid name" do
      before { @params = {:group => {:name => ""}} }

      it "doesn't change the group count" do
        expect { post :create, @params }.to_not change(Group, :count)
      end

      it "flashes an error message and redirects to new" do
        post :create, @params
        expect(flash[:error]).not_to be_empty
        expect(response).to redirect_to(new_group_url)
      end
    end
  end
end

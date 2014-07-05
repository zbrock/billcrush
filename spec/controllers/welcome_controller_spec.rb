require 'spec_helper'

describe WelcomeController, type: :controller do

  describe "#index" do
    it "renders" do
      get :index
      response.should be_success
    end
  end
end

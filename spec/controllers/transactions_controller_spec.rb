require 'spec_helper'

describe TransactionsController do
  before { @group = Factory(:group) }
  describe "#create" do
    before do
      @member_one = Factory(:member, :group => @group)
      @member_two = Factory(:member, :group => @group)
    end
    context "with valid params" do
      before do
        @params = {:group_id    => @group.to_param,
                   :transaction =>
                       {:description => "stuff and puff",
                        :amount      =>"30",
                        :payer       => @member_one.to_param,
                        :members     => {@member_one.to_param => "20", @member_two.to_param => "10"}
                       }}
      end

      it "changes the transaction count by 1" do
        expect { post :create, @params }.to change(Transaction, :count).by(1)
      end

      it "sets the values correctly" do
        post :create, @params
        transaction = assigns[:transaction]
        transaction.amount.should == 3000
        transaction.description.should == "stuff and puff"
        transaction.should be_active
      end

      it "sets the users balances appropriately" do
        @member_one.balance.should == 0
        @member_two.balance.should == 0
        post :create, @params
        @member_one.balance.should == 1000
        @member_two.balance.should == -1000
      end

      it "redirects to the group page" do
        post :create, @params
        response.should redirect_to(group_url(@group))
        flash[:message].should_not be_blank
      end
    end

    context "with invalid params" do
      before do
        @params = {:group_id    => @group.to_param,
                   :transaction =>
                       {:amount  => "300",
                        :payer   => @member_one.to_param,
                        :members => {@member_one.to_param=>"20"}
                       }}
      end

      it "changes the transaction count by 0" do
        expect { post :create, @params }.to_not change(Transaction.scoped_by_active(true), :count)
      end

      it "redirects to the new group page" do
        post :create, @params
        response.should redirect_to(group_url(@group))
        flash[:error].should_not be_blank
      end

      it "doesn't update people's balances" do
        @member_one.balance.should == 0
        @member_two.balance.should == 0
        post :create, @params
        @member_one.balance.should == 0
        @member_two.balance.should == 0
      end
    end
  end
  describe "#destroy" do
    before do
      @transaction = Factory(:transaction, :group => @group, :active => true)
      @params      = {:group_id => @group.to_param, :id => @transaction.to_param}
    end
    describe "with valid params" do
      it "marks the transaction as inactive" do
        delete :destroy, @params
        @transaction.reload.active.should be_false
        @transaction.deleted_at.should_not be_blank
        response.should redirect_to(group_url(@group))
        flash[:message].should_not be_blank
      end
    end
    describe "with invalid params" do
      it "flashes an error and redirects" do
        @params.merge!(:id => "foobar")
        delete :destroy, @params
        response.should redirect_to(group_url(@group))
        flash[:error].should_not be_blank
      end
    end
  end
end

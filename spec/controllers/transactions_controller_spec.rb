require 'spec_helper'

describe TransactionsController do
  describe "#create" do
    before do
      @group = Factory(:group)
      @member_one = Factory(:member, :group => @group)
      @member_two = Factory(:member, :group => @group)
    end
    context "with valid params" do
      before do
        @params = {:group_id => @group.to_param,
                    :transaction =>
                      {:description => "stuff and puff",
                       :amount =>"30",
                       :payer => @member_one.to_param,
                        :members =>
                     [{:amount=>"20", :id => @member_one.to_param},
                     {:amount=>"10", :id => @member_two.to_param}]
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
         @params = {:group_id => @group.to_param,
                    :transaction =>
                      {:amount => "300",
                       :payer => @member_one.to_param,
                        :members =>[]
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
    end
  end
end

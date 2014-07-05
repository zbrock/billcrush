require 'spec_helper'

describe TransactionsController, type: :controller do
  before { @group = Factory(:group) }
  describe "#create" do
    before do
      @member_one = Factory(:member, :group => @group)
      @member_two = Factory(:member, :group => @group)
    end
    context "with valid params" do
      before do
        # These values were selected to detect floating point rounding error.
        # (1.13 * 100).floor == 112, instead of 113
        # (1.1 * 100).ceil == 111, instead of 110
        # (0.03 * 100).floor == 3 and (0.03 * 100).ceil == 3
        @params = {:group_id    => @group.to_param,
                   :transaction =>
                       {:description => "stuff and puff",
                        :amount      => "1.13",
                        :payer       => @member_one.to_param,
                        :members     => {@member_one.to_param => "0.03", @member_two.to_param => "1.10"}
                       }}
      end
      context "when settlement is true" do
        it "marks the resulting transaction as a settlement" do
          @params[:transaction][:settlement] = "1"
          post :create, @params
          transaction = assigns[:transaction]
          transaction.settlement.should == true
        end
      end
      it "changes the transaction count by 1" do
        expect { post :create, @params }.to change(Transaction, :count).by(1)
      end

      it "sets the values correctly" do
        post :create, @params
        transaction = assigns[:transaction]
        transaction.amount.should == 113
        transaction.description.should == "stuff and puff"
        transaction.should be_active
      end

      it "sets the users balances appropriately" do
        @member_one.balance.should == 0
        @member_two.balance.should == 0
        post :create, @params
        @member_one.balance.should == -@member_two.balance
        @member_one.balance.should == 110
        @member_two.balance.should == -110
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

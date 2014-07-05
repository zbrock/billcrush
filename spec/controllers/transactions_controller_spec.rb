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
          expect(transaction.settlement).to eq(true)
        end
      end
      it "changes the transaction count by 1" do
        expect { post :create, @params }.to change(Transaction, :count).by(1)
      end

      it "sets the values correctly" do
        post :create, @params
        transaction = assigns[:transaction]
        expect(transaction.amount).to eq(113)
        expect(transaction.description).to eq("stuff and puff")
        expect(transaction).to be_active
      end

      it "sets the users balances appropriately" do
        expect(@member_one.balance).to eq(0)
        expect(@member_two.balance).to eq(0)
        post :create, @params
        expect(@member_one.balance).to eq(-@member_two.balance)
        expect(@member_one.balance).to eq(110)
        expect(@member_two.balance).to eq(-110)
      end

      it "redirects to the group page" do
        post :create, @params
        expect(response).to redirect_to(group_url(@group))
        expect(flash[:message]).not_to be_blank
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
        expect(response).to redirect_to(group_url(@group))
        expect(flash[:error]).not_to be_blank
      end

      it "doesn't update people's balances" do
        expect(@member_one.balance).to eq(0)
        expect(@member_two.balance).to eq(0)
        post :create, @params
        expect(@member_one.balance).to eq(0)
        expect(@member_two.balance).to eq(0)
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
        expect(@transaction.reload.active).to be_falsey
        expect(@transaction.deleted_at).not_to be_blank
        expect(response).to redirect_to(group_url(@group))
        expect(flash[:message]).not_to be_blank
      end
    end
    describe "with invalid params" do
      it "flashes an error and redirects" do
        @params.merge!(:id => "foobar")
        delete :destroy, @params
        expect(response).to redirect_to(group_url(@group))
        expect(flash[:error]).not_to be_blank
      end
    end
  end
end

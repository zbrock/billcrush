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
                      {:amount_cents=>"3000",
                       :payee => @member_one.to_param,
                        :members =>
                     [{@member_one.to_param => {"amount"=>"2000"}},
                      {@member_two.to_param => {"amount"=>"1000"}}]
        }}
      end

      it "changes the transaction count by 1" do
        expect { post :create, @params }.to change(Transaction, :count).by(1)
      end
      it "changes the Debt count by 2" do
        expect { post :create, @params }.to change(Debt, :count).by(2)
      end

      it "redirects to the group page" do
        post :create, @params
        response.should redirect_to(group_url(@group))
        flash[:message].should_not be_blank
      end
    end

    context "with invalid params" do
      before do
        @params = {:group_id => @group.to_param, :transactions =>
          []
        }
      end

      it "changes the transaction count by 0" do
        expect { post :create, @params }.to_not change(Transaction, :count)
      end

      it "redirects to the new group page" do
        post :create, @params
        response.should redirect_to(group_url(@group))
        flash[:message].should_not be_blank
      end
    end
  end
end

require 'spec_helper'

describe Member do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:group) }
  it { should belong_to(:group) }
  it { should have_many(:credits) }
  it { should have_many(:debits) }

  describe "#balance" do
    before{ @user = Factory(:member) }
    it "returns the sum of the members debits and credits" do
      Factory(:debit, :member => @user, :amount_cents => 25_00)
      Factory(:debit, :member => @user, :amount_cents => 15_00)
      Factory(:credit, :member => @user, :amount_cents => 10_00)
      @user.balance.should == -30_00
    end

    it "returns 0 if there are no debits and credits" do
      @user.balance.should == 0
    end

    it "ignores inactive debts" do
      Factory(:debit, :member => @user, :amount_cents => 25_00, :active => false)
      @user.balance.should == 0
    end
  end
end

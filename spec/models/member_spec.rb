require 'spec_helper'

describe Member do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:group) }
  it { should belong_to(:group) }
  it { should have_many(:credits) }
  it { should have_many(:debits) }

  describe "#balance" do
    it "returns the sum of the members debits and credits" do
      user = Factory(:member)
      Factory(:debit, :creditor => user, :debtor => Factory(:member), :amount_cents => 25_00)
      Factory(:debit, :creditor => user, :debtor => Factory(:member), :amount_cents => 15_00)
      Factory(:debit, :creditor => Factory(:member), :debtor => user, :amount_cents => 5_00)
      user.balance.should == 35_00
    end
    it "returns 0 if there are no debits and credits" do
      Factory(:member).balance.should == 0
    end

    it "ignores inactive debts" do
      user = Factory(:member)
      Factory(:debit, :creditor => user, :active => false, :debtor => Factory(:member), :amount_cents => 25_00)
      user.balance.should == 0
    end
  end
end

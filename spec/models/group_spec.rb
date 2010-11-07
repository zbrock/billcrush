require 'spec_helper'

describe Group do
  it { should validate_presence_of(:name) }
  it { should have_many(:members) }
  it { should have_many(:transactions) }
  describe "life cycle" do
    describe "canonicalized_name" do
      [
        ["Joe's Schmoes", "joe-s-schmoes"],
        ["Sanchez", "sanchez"],
        ["PETA", "peta"],
      ].each do |name|
        it "turns the name #{name[0]} into something url friendly" do
          group = Factory.build(:group, :name => name[0])
          group.canonicalized_name.should be_blank
          group.save!
          group.canonicalized_name.should == name[1]
        end
      end
    end
  end
  describe "#best_way_to_settle" do

    it "returns an empty array if there are no members" do
      Factory(:group).best_way_to_settle.should == []
    end
    context "with members" do
      before do
        @group = Factory(:group)
        @member_one = Factory(:member, :group => @group)
        @member_two = Factory(:member, :group => @group)
        @member_three = Factory(:member, :group => @group)
        @member_four = Factory(:member, :group => @group)
      end

      it "returns an empty array when there is no debt to settle" do
        @group.best_way_to_settle.should == []
      end

      it "returns an array of hashes showing the best way to settle" do
        Factory(:debit, :debtor => @member_one, :creditor => @member_two, :amount_cents => 10_00)
        Factory(:debit, :debtor => @member_three, :creditor => @member_two, :amount_cents => 10_00)
        Factory(:debit, :debtor => @member_two, :creditor => @member_one, :amount_cents => 5_00)
        Factory(:debit, :debtor => @member_three, :creditor => @member_one, :amount_cents => 1_00)
        Factory(:debit, :debtor => @member_one, :creditor => @member_four, :amount_cents => 1_00)
        @member_one.balance.should == -5_00
        @member_two.balance.should == 15_00
        @member_three.balance.should == -11_00
        @member_four.balance.should == 1_00

        @group.best_way_to_settle.should include({:payer => @member_three, :payee => @member_two, :amount => 11_00})
        @group.best_way_to_settle.should include({:payer => @member_one, :payee => @member_two, :amount => 4_00})
        @group.best_way_to_settle.should include({:payer => @member_one, :payee => @member_four, :amount => 1_00})
        @group.best_way_to_settle.size.should == 3
      end

      it "doesn't include people who don't have debt" do
        Factory(:debit, :debtor => @member_one, :creditor => @member_two, :amount_cents => 10_93)
        @member_one.balance.should == -10_93
        @member_two.balance.should == 10_93
        @group.best_way_to_settle.should == [{:payer => @member_one, :payee => @member_two, :amount => 10_93}]
      end

      it "returns an empty array if all the debts cancel" do
        Factory(:debit, :debtor => @member_one, :creditor => @member_two, :amount_cents => 10_00)
        Factory(:debit, :debtor => @member_two, :creditor => @member_three, :amount_cents => 10_00)
        Factory(:debit, :debtor => @member_three, :creditor => @member_one, :amount_cents => 10_00)
        @group.best_way_to_settle.should == []
      end
    end
  end
end
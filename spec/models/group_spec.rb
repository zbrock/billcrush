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

      context "with data that will never converge" do
        it "times out" do
          Factory(:debit, :member => @member_one, :amount_cents => 100)
          expect { @group.best_way_to_settle }.to raise_error(Timeout::Error)
        end
      end

      it "returns an empty array when there is no debt to settle" do
        @group.best_way_to_settle.should == []
      end

      it "returns an array of hashes showing the best way to settle" do
        create_debit_credit_pair(@member_one, @member_two, 10_00)
        create_debit_credit_pair(@member_three, @member_two, 10_00)
        create_debit_credit_pair(@member_two, @member_one, 5_00)
        create_debit_credit_pair(@member_three, @member_one, 1_00)
        create_debit_credit_pair(@member_one, @member_four, 1_00)

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
        create_debit_credit_pair(@member_one, @member_two, 10_93)

        @member_one.balance.should == -10_93
        @member_two.balance.should == 10_93
        @group.best_way_to_settle.should == [{:payer => @member_one, :payee => @member_two, :amount => 10_93}]
      end

      it "returns an empty array if all the debts cancel" do
        create_debit_credit_pair(@member_one, @member_two, 10_93)
        create_debit_credit_pair(@member_two, @member_three, 10_93)
        create_debit_credit_pair(@member_three, @member_one, 10_93)

        @group.best_way_to_settle.should == []
      end
    end
  end
end
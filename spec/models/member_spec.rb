require 'spec_helper'

describe Member, :type => :model do
  before{ @user = Factory(:member) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:group) }
  it { is_expected.to belong_to(:group) }
  it { is_expected.to have_many(:credits) }
  it { is_expected.to have_many(:debits) }

  describe "#balance" do
    it "returns the sum of the members debits and credits" do
      Factory(:debit, :member => @user, :amount_cents => 25_00)
      Factory(:debit, :member => @user, :amount_cents => 15_00)
      Factory(:credit, :member => @user, :amount_cents => 10_00)
      expect(@user.balance).to eq(-30_00)
    end

    it "returns 0 if there are no debits and credits" do
      expect(@user.balance).to eq(0)
    end

    it "ignores inactive debts" do
      Factory(:debit, :member => @user, :amount_cents => 25_00, :active => false)
      expect(@user.balance).to eq(0)
    end
  end
  describe "#debits_for_transaction" do
    it "returns the sum of debits for the given transaction" do
      transaction = Factory(:transaction)
      Factory(:debit, :member => @user, :amount_cents => 15_00)
      Factory(:debit, :member => @user, :amount_cents => 25_00, :transaction => transaction)
      expect(@user.debits_for_transaction(transaction)).to eq(25_00)
    end
  end
end

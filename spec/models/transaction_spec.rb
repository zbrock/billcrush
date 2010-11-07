require 'spec_helper'

describe Transaction do
  it { should have_many(:debits) }
  it { should belong_to(:group) }
  it { should validate_presence_of(:group) }
  it { should validate_numericality_of(:amount) }

  describe "#validate_and_activate!" do
    it "is false if there are no debits" do
      transaction = Factory(:transaction)
      transaction.validate_and_activate!.should be_false
      transaction.reload.should_not be_active
    end

    it "is false and does not activate if the associated debt amounts don't add up to the amount_cents" do
      transaction = Factory(:transaction, :amount => 2000)
      Factory(:debit, :amount_cents => 1000, :transaction => transaction, :active => false)
      transaction.debits.each{|debt| debt.should_not be_active}
      transaction.validate_and_activate!.should be_false
      transaction.reload.should_not be_active
      transaction.debits.each{|debt| debt.should_not be_active}
    end


    it "is true and activates if the associated debt amounts do add up to the amount cents" do
      transaction = Factory(:transaction, :amount => 1000)
      Factory(:debit, :amount_cents => 1000, :transaction => transaction, :active => false)
      transaction.debits.each{|debt| debt.should_not be_active}      
      transaction.validate_and_activate!.should be_true
      transaction.reload.should be_active
      transaction.debits.each{|debt| debt.should be_active}
    end
  end
end

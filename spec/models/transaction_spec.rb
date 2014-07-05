require 'spec_helper'

describe Transaction, type: :model do
  it { should have_many(:debits) }
  it { should have_many(:credits) }
  it { should belong_to(:group) }
  it { should validate_presence_of(:group) }
  it { should validate_numericality_of(:amount) }

  describe "#validate_and_activate!" do
    it "is false if there are no debits or credits" do
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

    it "is false if the associated debt amounts add up to the amount cents but the debit and credit sum is not 0" do
      transaction = Factory(:transaction, :amount => 1000)
      Factory(:debit, :amount_cents => 500, :transaction => transaction, :active => false)
      Factory(:credit, :amount_cents => 500, :transaction => transaction, :active => false)
      transaction.debits.each{|debt| debt.should_not be_active}
      transaction.credits.each{|debt| debt.should_not be_active}
      transaction.validate_and_activate!.should be_false
      transaction.reload.should_not be_active
      transaction.debits.each{|debt| debt.should_not be_active}
      transaction.credits.each{|debt| debt.should_not be_active}
    end

    it "is false if the associated debt amounts add up to zero but the debits don't add up to the amount cents" do
      transaction = Factory(:transaction, :amount => 1000)
      Factory(:debit, :amount_cents => 1000, :transaction => transaction, :active => false)
      transaction.debits.each{|debt| debt.should_not be_active}
      transaction.validate_and_activate!.should be_false
      transaction.reload.should_not be_active
      transaction.debits.each{|debt| debt.should_not be_active}

    end

    it "is true and activates if the associated debt amounts do add up to the amount cents and the sum is 0" do
      transaction = Factory(:transaction, :amount => 1000)
      Factory(:debit, :amount_cents => 1000, :transaction => transaction, :active => false)
      Factory(:credit, :amount_cents => 1000, :transaction => transaction, :active => false)
      transaction.debits.each{|debt| debt.should_not be_active}
      transaction.credits.each{|debt| debt.should_not be_active}
      transaction.validate_and_activate!.should be_true
      transaction.reload.should be_active
      transaction.debits.each{|debt| debt.should be_active}
      transaction.credits.each{|debt| debt.should be_active}
    end
  end
  describe "#mark_as_deleted!" do
    it "marks the transaction and all debits and credits as inactive" do
      transaction = Factory(:transaction, :amount => 1000, :active => true)
      Factory(:debit, :amount_cents => 1000, :transaction => transaction, :active => true)
      Factory(:credit, :amount_cents => 1000, :transaction => transaction, :active => true)
      transaction.mark_as_deleted!
      transaction.reload.should_not be_active
      transaction.debits.each{|debt| debt.should_not be_active}
      transaction.credits.each{|debt| debt.should_not be_active}
    end

    it "sets the deleted_at time" do
      transaction = Factory(:transaction, :amount => 1000, :active => true)
      transaction.deleted_at.should be_nil
      transaction.mark_as_deleted!
      transaction.deleted_at.should_not be_blank
    end
  end
end

require 'spec_helper'

describe Transaction, type: :model do
  it { is_expected.to have_many(:debits) }
  it { is_expected.to have_many(:credits) }
  it { is_expected.to belong_to(:group) }
  it { is_expected.to validate_presence_of(:group) }
  it { is_expected.to validate_numericality_of(:amount) }

  describe "#validate_and_activate!" do
    it "is false if there are no debits or credits" do
      transaction = Factory(:transaction)
      expect(transaction.validate_and_activate!).to be_falsey
      expect(transaction.reload).not_to be_active
    end

    it "is false and does not activate if the associated debt amounts don't add up to the amount_cents" do
      transaction = Factory(:transaction, :amount => 2000)
      Factory(:debit, :amount_cents => 1000, :transaction => transaction, :active => false)
      transaction.debits.each{|debt| expect(debt).not_to be_active}
      expect(transaction.validate_and_activate!).to be_falsey
      expect(transaction.reload).not_to be_active
      transaction.debits.each{|debt| expect(debt).not_to be_active}
    end

    it "is false if the associated debt amounts add up to the amount cents but the debit and credit sum is not 0" do
      transaction = Factory(:transaction, :amount => 1000)
      Factory(:debit, :amount_cents => 500, :transaction => transaction, :active => false)
      Factory(:credit, :amount_cents => 500, :transaction => transaction, :active => false)
      transaction.debits.each{|debt| expect(debt).not_to be_active}
      transaction.credits.each{|debt| expect(debt).not_to be_active}
      expect(transaction.validate_and_activate!).to be_falsey
      expect(transaction.reload).not_to be_active
      transaction.debits.each{|debt| expect(debt).not_to be_active}
      transaction.credits.each{|debt| expect(debt).not_to be_active}
    end

    it "is false if the associated debt amounts add up to zero but the debits don't add up to the amount cents" do
      transaction = Factory(:transaction, :amount => 1000)
      Factory(:debit, :amount_cents => 1000, :transaction => transaction, :active => false)
      transaction.debits.each{|debt| expect(debt).not_to be_active}
      expect(transaction.validate_and_activate!).to be_falsey
      expect(transaction.reload).not_to be_active
      transaction.debits.each{|debt| expect(debt).not_to be_active}

    end

    it "is true and activates if the associated debt amounts do add up to the amount cents and the sum is 0" do
      transaction = Factory(:transaction, :amount => 1000)
      Factory(:debit, :amount_cents => 1000, :transaction => transaction, :active => false)
      Factory(:credit, :amount_cents => 1000, :transaction => transaction, :active => false)
      transaction.debits.each{|debt| expect(debt).not_to be_active}
      transaction.credits.each{|debt| expect(debt).not_to be_active}
      expect(transaction.validate_and_activate!).to be_truthy
      expect(transaction.reload).to be_active
      transaction.debits.each{|debt| expect(debt).to be_active}
      transaction.credits.each{|debt| expect(debt).to be_active}
    end
  end
  describe "#mark_as_deleted!" do
    it "marks the transaction and all debits and credits as inactive" do
      transaction = Factory(:transaction, :amount => 1000, :active => true)
      Factory(:debit, :amount_cents => 1000, :transaction => transaction, :active => true)
      Factory(:credit, :amount_cents => 1000, :transaction => transaction, :active => true)
      transaction.mark_as_deleted!
      expect(transaction.reload).not_to be_active
      transaction.debits.each{|debt| expect(debt).not_to be_active}
      transaction.credits.each{|debt| expect(debt).not_to be_active}
    end

    it "sets the deleted_at time" do
      transaction = Factory(:transaction, :amount => 1000, :active => true)
      expect(transaction.deleted_at).to be_nil
      transaction.mark_as_deleted!
      expect(transaction.deleted_at).not_to be_blank
    end
  end
end

require 'spec_helper'

describe Debt do
  it { should validate_presence_of(:amount_cents) }
  it { should validate_presence_of(:debtor) }
  it { should validate_presence_of(:creditor) }
  
  it { should belong_to(:debtor) }
  it { should belong_to(:creditor) }
  it { should belong_to(:transaction) }
end

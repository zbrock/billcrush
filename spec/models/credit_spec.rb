require 'spec_helper'

describe Credit do
  it { should validate_presence_of(:amount_cents) }
  it { should validate_presence_of(:member) }

  it { should belong_to(:member) }
  it { should belong_to(:transaction) }
end

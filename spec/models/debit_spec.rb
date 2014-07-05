require 'spec_helper'

describe Debit, :type => :model do
  it { is_expected.to validate_presence_of(:amount_cents) }
  it { is_expected.to validate_presence_of(:member) }

  it { is_expected.to belong_to(:member) }
  it { is_expected.to belong_to(:transaction) }
end

require 'spec_helper'

describe Transaction do
  it{ should have_many(:debts)}
  it{ should belong_to(:group)}
  it { should validate_presence_of(:group) }

end

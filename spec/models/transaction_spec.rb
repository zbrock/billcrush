require 'spec_helper'

describe Transaction do
  it{ should have_many(:debts)}
end

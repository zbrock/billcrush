require 'spec_helper'

describe Member do
  it{should validate_presence_of(:name)}
  it{should validate_presence_of(:group)}
  it{ should belong_to(:group) }
end

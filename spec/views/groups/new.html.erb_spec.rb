require 'spec_helper'

describe "groups/new.html.erb" do
  before do
    assign(:group, Group.new)
  end
  it_should_behave_like "strict xhtml"
end
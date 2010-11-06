require 'spec_helper'

describe "groups/index.html.erb" do
  before do
    assign(:groups, [Factory(:group), Factory(:group)])
  end
  it_should_behave_like "strict xhtml"
end
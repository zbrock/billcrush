require 'spec_helper'

describe "groups/show.html.erb" do
  before do
    assign(:group, Factory(:group))
  end
  it_should_behave_like "strict xhtml"
end
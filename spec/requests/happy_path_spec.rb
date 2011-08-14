require 'spec_helper'

describe "creating a group", :type => :request do
  it "allows a user to create a group, add members and add an expense" do
    group_name = "A New Group"
    visit('/groups/new')
    fill_in 'Name', :with => group_name
    click_button 'Create group'
    
    page.should have_content(group_name)
    page.should have_content("This group doesn't have any members yet.")
    fill_in 'Name', :with => 'Bob'
    click_button 'Add member'
    
    page.should have_no_content("This group doesn't have any members yet.")
    page.should have_content("Bob added!")
    click_button 'Done'
    
    page.should have_content("The group must contain 2 or more members to add transactions")
    click_link "add members"

    fill_in 'Name', :with => 'Alice'
    click_button 'Add member'
    page.should have_content("Alice added!")
    click_button 'Done'
    
    page.should have_content(group_name)
    page.should have_content("Bob")
    page.should have_content("Alice")

    fill_in 'Description', :with => 'Rent'
    fill_in 'transaction_amount', :with => '1000'
    
    fill_in 'transaction-amount-0', :with => '600'
    fill_in 'transaction-amount-1', :with => '400'

    click_button 'Add transaction'
    
    page.should have_content("Bob: $400.00")
    page.should have_content("Alice: -$400.00")
    page.should have_content("Alice pays Bob $400.00")    
  end
end

describe "error message" do
  it "shows a message for an invalid group" do
    visit('/groups/new')
    click_button 'Create group'
    page.should have_content("Bad group name")
  end
end

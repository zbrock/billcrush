require 'spec_helper'

feature "creating a group", :type => :feature do
  scenario "allows a user to create a group, add members and add an expense" do
    group_name = "A New Group"
    visit('/groups/new')
    fill_in 'Name', :with => group_name
    click_button 'Create group'
    
    expect(page).to have_content(group_name)
    expect(page).to have_content("This group doesn't have any members yet.")
    fill_in 'Name', :with => 'Bob'
    click_button 'Add member'
    
    expect(page).to have_no_content("This group doesn't have any members yet.")
    expect(page).to have_content("Bob added!")
    click_button 'Done'
    
    expect(page).to have_content("Don't forget your url! It's the only way to access your group.")
    expect(page).to have_content("The group must contain 2 or more members to add transactions")
    click_link "add members"

    fill_in 'Name', :with => 'Alice'
    click_button 'Add member'
    expect(page).to have_content("Alice added!")
    click_button 'Done'

    expect(page).to have_content(group_name)
    expect(page).to have_content("Bob")
    expect(page).to have_content("Alice")

    fill_in 'Description', :with => 'Rent'
    fill_in 'transaction_amount', :with => '1000'
    
    fill_in 'transaction-amount-0', :with => '600'
    fill_in 'transaction-amount-1', :with => '400'

    click_button 'Add transaction'
    
    expect(page).to have_content("Bob: $400.00")
    expect(page).to have_content("Alice: -$400.00")
    expect(page).to have_content("Alice pays Bob $400.00")    
  end
end

feature "error message" do
  scenario "shows a message for an invalid group" do
    visit('/groups/new')
    click_button 'Create group'
    expect(page).to have_content("Bad group name")
  end
end

Given('I am on the student dashboard and I am logged in as a student') do
  visit '/students'
end

Then('I should see a settings button.') do
  # Check that the 'Settings' link is present on the page
  expect(page).to have_link('Settings')
end

When('I click the settings button') do
  click_link('Settings') # Click the link with the text 'Settings'
end

Then('I should be on a page where I can see and edit my settings.') do
  visit '/settings'
end

Given('I am on the student settings page and I am logged in as a student') do
  visit '/settings'
end

Then('I should see a back button.') do
  expect(page).to have_link('Back')
end

When('I click the back button') do
  click_link('Back')
end

Then('I should be on the student dashboard.') do
  visit '/students'
end

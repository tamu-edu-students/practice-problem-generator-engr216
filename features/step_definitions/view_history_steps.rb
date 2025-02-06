Given('I am on the student dashboard') do
  visit '/students'
end

When('I select the history button') do
  expect(page).to have_link('History')
end

Then('I should be on the history page') do
  visit '/history'
end

Given('I am on the history page') do
  visit '/history'
end

Then('I should see problems I have done') do
  expect(page).to have_text('Problems')
end

Then('I should see how I did on them') do
  expect(page).to have_text('Answers')
end

When('I click the back button on the history page') do
  click_link('Back')
end

Then('I should be on the student dashboard') do
  visit '/students'
end

Given('I am on the student dashboard') do
  visit '/practice_problems'
end

When('I select the history button') do
  expect(page).to have_button('Past Problems')
end

Then('I should be on the history page') do
  visit '/history'
end

Given('I am on the history page') do
  visit '/history'
end

Then('I should see problems I have done') do
  expect(page).to have_text('Problem Select')
end

Then('I should see how I did on them') do
  expect(page).to have_text('Answers')
end

When('I click the Problem Select button on the history page') do
  click_link('Problem Select')
end

Then('I should be on the student dashboard') do
  visit '/practice_problems'
end

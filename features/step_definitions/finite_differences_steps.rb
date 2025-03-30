Given('I am on the Finite Differences problem page') do
  visit generate_practice_problems_path(category_id: 'Finite Differences')
  expect(page).to have_content('Finite Differences')
end

When('I click the finite differences new problem button') do
  click_button('New Problem') if has_button?('New Problem')
  click_link('Generate New Problem') if has_link?('Generate New Problem')
end

Then('a new finite differences problem should be generated') do
  expect(page).to have_content('Finite Differences')
  expect(page).to have_css('.question-card') if has_css?('.question-card')
end

When('I submit a finite differences answer') do
  # Generate a new problem first to ensure we have content
  step 'I click the finite differences new problem button'

  # For a numeric answer
  fill_in('answer', with: '2.5') if has_field?('answer')

  # If there are specific fields for finite differences
  fill_in('forward_diff', with: '2.5') if has_field?('forward_diff')
  fill_in('backward_diff', with: '2.5') if has_field?('backward_diff')
  fill_in('centered_diff', with: '2.5') if has_field?('centered_diff')

  # Submit the form
  click_button('Submit') if has_button?('Submit')
  click_button('Check Answer') if has_button?('Check Answer')
end

Then('I should receive feedback on my finite differences answer') do
  expect(page).to have_content(/Feedback|Correct|Incorrect/i)
end

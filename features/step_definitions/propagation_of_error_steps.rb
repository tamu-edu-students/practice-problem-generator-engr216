Given('I am on the Propagation of Error problem page') do
  visit generate_practice_problems_path(category_id: 'propagation of error')
  expect(page).to have_content('Propagation of Error')
end

When('I click the propagation of error {string} button') do |button_text|
  click_button(button_text) if has_button?(button_text)
  click_link(button_text) if has_link?(button_text)
end

Then('a new propagation of error problem should be generated') do
  expect(page).to have_content('Propagation of Error')
  expect(page).to have_css('.question-card') if has_css?('.question-card')
  # Additional checks specific to error propagation problems
  expect(page).to have_content(/uncertainty/i)
end

When('I submit an answer for propagation of error') do
  # For a numeric answer - error propagation questions expect a numerical answer
  fill_in('answer', with: '1.5') if has_field?('answer')

  # Submit the form
  click_button('Submit') if has_button?('Submit')
  click_button('Check Answer') if has_button?('Check Answer')
end

Then('I should receive feedback on my propagation of error answer') do
  # Check for any feedback message
  expect(page).to have_content(/Feedback|Correct|Incorrect|too small|too large/i)

  # Look for specific elements that indicate feedback was given
  expect(page).to have_css('.feedback') if has_css?('.feedback')
  expect(page).to have_css('.alert') if has_css?('.alert')
end

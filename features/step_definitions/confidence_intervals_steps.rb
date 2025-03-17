Given('I am on the Confidence Interval Page') do
  visit generate_practice_problems_path(category_id: 'Confidence Intervals')
end

Given('I on the Confidence Interval Page') do
  visit generate_practice_problems_path(category_id: 'Confidence Intervals')
end

When('I click the new confidence interval problem button') do
  click_link 'Generate New Problem'
end

When('I submit a confidence interval answer') do
  # Your implementation for submitting confidence interval answers
  fill_in 'lower_bound', with: '10'
  fill_in 'upper_bound', with: '20'
  click_button 'Check Answer'
end

Then('a new Confidence Interval problem should be dynamically generated') do
  expect(page).to have_css('h1', text: /Question:/)
  expect(page).to have_field('lower_bound')
  expect(page).to have_field('upper_bound')
end

Then('I should be given feedback on my confidence interval answer') do
  # This will pass if either success or error message is shown
  expect(page).to have_css('div', text: /Correct|Incorrect/)
end

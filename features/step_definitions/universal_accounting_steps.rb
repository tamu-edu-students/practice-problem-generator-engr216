Given('I am on the "Universal Accounting Equation" page for UAE') do
  visit generate_practice_problems_path(category_id: 'Universal Accounting Equation')
end

When('I click the "new problem" button for Universal Accounting Equation') do
  click_link 'Generate New Problem'
end

When('I submit an answer for Universal Accounting Equation') do
  # Find input fields and fill them with test values
  fill_in 'answer', with: '42'
  click_button 'Check Answer'
end

Then('a new "Universal Accounting Equation" problem should be dynamically generated for UAE') do
  expect(page).to have_css('h1', text: 'Universal Accounting Equation Problem:')
end

Then('I should receive feedback on my answer for Universal Accounting Equation') do
  # This will pass if either success or error message is shown
  expect(page).to have_css('div', text: /Correct|Incorrect/)
end

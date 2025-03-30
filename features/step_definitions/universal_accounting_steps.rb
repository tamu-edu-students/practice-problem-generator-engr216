Given('I am on the Universal Accounting Equation problem page') do
  visit generate_practice_problems_path(category_id: 'Universal Accounting Equation')
end

When('I click the "new problem" button for Universal Accounting Equation') do
  click_link 'Generate New Problem'
end

When('I submit an answer for Universal Accounting Equation') do
  # Generate a problem to ensure there's content
  step 'I click the "new problem" button for Universal Accounting Equation'

  # Fill all text inputs with a value
  page.all('input[type="text"]').find_each do |input|
    input.set('100.00')
  end

  click_button 'Check Answer'
end

Then('a new universal accounting equation problem should be generated') do
  expect(page).to have_css('h1', text: /Universal Account Equations Problem/i)
end

Then('I should receive feedback on my answer for Universal Accounting Equation') do
  # This will pass if either success or error message is shown
  expect(page).to have_css('div', text: /Correct|Incorrect/)
end

Given('I am on the Experimental Statistics Page') do
  @category = 'Experimental Statistics'
  visit practice_problems_path
  click_link 'Experimental Statistics'
end

When('I click the new experimental statistics problem button') do
  click_link 'Generate New Problem'
end

Then('a new Experimental Statistics problem should be dynamically generated') do
  expect(page).to have_content('Category: Experimental Statistics')
  expect(page).to have_css('input[type="text"]')
end

When('I submit an experimental statistics answer') do
  # Your implementation for submitting experimental statistics answers
  fill_in 'answer', with: '42'
  click_button 'Check Answer'
end

Then('I should be given feedback on my experimental statistics answer') do
  # This will pass if either success or error message is shown
  expect(page).to have_css('div', text: /Correct|Incorrect/)
end

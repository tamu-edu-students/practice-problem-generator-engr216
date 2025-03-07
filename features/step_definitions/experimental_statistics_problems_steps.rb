Given('I am on the Experimental Statistics Page') do
  @category = 'Experimental Statistics'
  visit practice_problems_path
  click_link 'Experimental Statistics'
end

When('I click the new problem button') do
  click_link 'Generate New Problem'
end

Then('a new Experimental Statistics problem should be dynamically generated') do
  expect(page).to have_content('Category: Experimental Statistics')
  expect(page).to have_css('input[type="text"]')
end

When('I submit an answer') do
  all('form input[type="text"]').each do |input|
    input.fill_in with: '10.00'
  end
  click_button 'Check Answer'
end

Then('I should be given feedback on my answer') do
  feedback_present = page.has_content?('Correct!') ||
                     page.has_content?('Incorrect') ||
                     page.has_content?('too small') ||
                     page.has_content?('too large')
  expect(feedback_present).to be true
end

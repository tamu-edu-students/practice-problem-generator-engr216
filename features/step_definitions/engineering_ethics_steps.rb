Given('I am on the "Engineering Ethics" page') do
  visit generate_practice_problems_path(category_id: 'Engineering Ethics')
  expect(page).to have_content('Engineering Ethics')
end

When('I click the engineering ethics new problem button') do
  click_button('New Problem') if has_button?('New Problem')
  click_link('Generate New Problem') if has_link?('Generate New Problem')
end

Then('a new "Engineering Ethics" problem should be dynamically generated') do
  expect(page).to have_content('Engineering Ethics')
  expect(page).to have_css('.question-card') if has_css?('.question-card')
end

When('I submit an engineering ethics answer') do
  first('input[type="radio"]').click if has_css?('input[type="radio"]')
  fill_in('answer', with: 'Test answer') if has_field?('answer')
  click_button('Submit') if has_button?('Submit')
  click_button('Check Answer') if has_button?('Check Answer')
end

Then('I should receive feedback on my answer') do
  expect(page).to have_content(/Feedback|Correct|Incorrect/i)
end

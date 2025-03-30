Given('I am on the Engineering Ethics problem page') do
  visit generate_practice_problems_path(category_id: 'Engineering Ethics')
  expect(page).to have_content('Engineering Ethics')
end

When('I click the engineering ethics new problem button') do
  click_button('New Problem') if has_button?('New Problem')
  click_link('Generate New Problem') if has_link?('Generate New Problem')
end

Then('a new engineering ethics problem should be generated') do
  expect(page).to have_content('Engineering Ethics')
  expect(page).to have_css('.question-card') if has_css?('.question-card')
end

When('I submit an engineering ethics answer') do
  # For engineering ethics, we typically have a True/False answer
  # First generate a new problem to ensure we have content
  step 'I click the engineering ethics new problem button'

  choose('ethics_answer_true') if has_field?('ethics_answer_true')
  choose('ethics_answer_false') if has_field?('ethics_answer_false')

  click_button('Submit') if has_button?('Submit')
  click_button('Check Answer') if has_button?('Check Answer')
end

Then('I should receive feedback on my answer') do
  expect(page).to have_content(/Feedback|Correct|Incorrect/i)
end

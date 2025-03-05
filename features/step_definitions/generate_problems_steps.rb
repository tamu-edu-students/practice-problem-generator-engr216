# features/step_definitions/generate_problems_steps.rb

Given('I am on the select problem category page') do
  # Ensure there's at least one question with the desired category exists.
  if Question.where(category: 'Measurement & Error').count.zero?
    q = Question.new(category: 'Measurement & Error', question: 'Sample question for Measurement & Error')
    q.write_attribute(:answer_choices, ["TBD"])  # use the new column and pass an array
    q.save!
  end
  visit practice_problems_path
end

When('I select a category') do
  # Assuming your select category page displays categories as links with the category names.
  category = Question.first.category
  click_link(category)
end

Then('I should be on the generate problem page') do
  expect(page).to have_content('Question:')
end

Given('I am on the generate problems page') do
  # Ensure a question exists with the desired category, then visit the generate page for that category.
  question_record = Question.find_by(category: 'Measurement & Error') ||
                    Question.create!(
                      category: 'Measurement & Error',
                      question: 'Sample question for Measurement & Error',
                      answer_choices: ['TBD']  # Updated attribute name from "answers" to "answer_choices"
                    )
  visit generate_practice_problems_path(category: question_record.category)
end

When('I click generate problem') do
  click_link 'Generate New Problem'
end

Then('I should see a problem') do
  expect(page).to have_content('Question:')
end

Given('I have already generated a problem') do
  @first_question = find('p.font-semibold.text-3xl', match: :first).text
end

Then('I should see a different problem') do
  new_question = find('p.font-semibold.text-3xl', match: :first).text
  expect(new_question).not_to eq(@first_question)
end

When('I click change category') do
  click_link 'Change Category'
end

Then('I should be on the select problem category page') do
  expect(page).to have_content('Select Category')
end

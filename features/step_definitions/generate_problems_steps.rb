# features/step_definitions/generate_problems_steps.rb

Given('I am on the select problem category page') do
  # Ensure there's at least one question with the desired category exists.
  if Question.where(category: 'Measurement & Error').count.zero?
    q = Question.new(category: 'Measurement & Error', question: 'Sample question for Measurement & Error')
    q.write_attribute(:answer_choices, ['TBD']) # use the new column and pass an array
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
                      answer_choices: ['TBD'] # Updated attribute name from "answers" to "answer_choices"
                    )
  # IMPORTANT: Pass the category string under the key `category_id`
  visit generate_practice_problems_path(category_id: question_record.category)
end

When('I click generate problem') do
  click_link 'Generate New Problem'
end

Then('I should see a problem') do
  expect(page).to have_content('Question:')
end

Given('I have already generated a problem') do
  # Create a question with the desired category if it doesn't exist.
  question_record = Question.find_by(category: 'Experimental Statistics') ||
                    Question.create!(
                      category: 'Experimental Statistics',
                      question: 'Sample question for Experimental Statistics',
                      answer_choices: ['TBD']
                    )
  # Instead of using a Category model, set the category as a string.
  @category = question_record.category

  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                       uid: '123',
                                                                       provider: 'google_oauth2',
                                                                       info: {
                                                                         email: 'test_student@tamu.edu',
                                                                         first_name: 'test',
                                                                         last_name: 'student'
                                                                       }
                                                                     })
  visit '/auth/google_oauth2/callback?state=student'

  click_link 'Experimental Statistics'
  expect(page).to have_content('Question:')
  @current_problem_text = find('.bg-gray-800').text
end

Then('I should see a different problem') do
  click_link 'Generate New Problem'
  new_problem_text = find('.bg-gray-800').text
  expect(new_problem_text).not_to eq(@current_problem_text)
end

When('I click change category') do
  click_link 'Change Category'
end

Then('I should be on the select problem category page') do
  expect(page).to have_content('Select Category')
end

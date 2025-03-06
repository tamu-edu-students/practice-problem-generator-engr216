# features/step_definitions/generate_problems_steps.rb

Given('I am on the select problem category page') do
  Category.create!(name: 'Measurement & Error') if Category.count.zero?
  visit practice_problems_path
end

When('I select a category') do
  category = Category.first
  click_link(category.name)
end

Then('I should be on the generate problem page') do
  expect(page).to have_content('Question:')
end

Given('I am on the generate problems page') do
  category = Category.first || Category.create!(name: 'Measurement & Error')
  visit generate_practice_problems_path(category_id: category.id)
end

When('I click generate problem') do
  click_link 'Generate New Problem'
end

Then('I should see a problem') do
  expect(page).to have_content('Question:')
end

Given('I have already generated a problem') do
  # Create the specific category first
  Category.find_or_create_by!(name: 'Experimental Statistics')

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

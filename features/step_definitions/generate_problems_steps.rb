# features/step_definitions/generate_problems_steps.rb

Given('I am on the select problem category page') do
  @student = Student.find_or_create_by!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789'
  )
  login_as_student
  visit practice_problems_path
  expect(page).to have_content('Select Category')
end

When('I select a category') do
  click_link 'Experimental Statistics'
end

Then('I should be on the generate problem page') do
  expect(page).to have_content('Question:')
end

Given('I am on the generate problems page') do
  login_as_student
  visit practice_problems_path
  click_link 'Experimental Statistics'
  expect(page).to have_content('Question:')
end

When('I click generate problem') do
  click_link 'Generate New Problem'
end

Then('I should see a problem') do
  expect(page).to have_content('Question:')
  store_page_content
end

Given('I have already generated a problem') do
  click_link 'Generate New Problem'
end

Then('I should see a different problem') do
  expect(page.body).not_to eq(@previous_page_content)
end

When('I click change category') do
  click_link 'Change Category'
end

Then('I should be on the select problem category page') do
  expect(page).to have_content('Select Category')
end

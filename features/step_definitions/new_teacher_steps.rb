Then('I should be on the add teacher page') do
  expect(page).to have_current_path(new_teacher_path)
  expect(page).to have_content('Add New Teacher')
end

Then('the form should include fields for name and email') do
  expect(page).to have_field('Name')
  expect(page).to have_field('Email')
  expect(page).to have_content('Email must be a valid @tamu.edu address')
end

Given('I am on the add teacher page') do
  visit new_teacher_path
  expect(page).to have_content('Add New Teacher')
end

Given('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

Then('the new teacher should be added to the database') do
  @teacher = Teacher.find_by(email: 'jane.doe@tamu.edu')
  expect(@teacher).not_to be_nil
  expect(@teacher.name).to eq('Jane Doe')
  # Update the teacher count after successfully adding a teacher
  @scenario_teacher_count = Teacher.count
end

Then('I should see a confirmation message') do
  expect(page).to have_content('Teacher was successfully created')
end

When('I leave one or more fields blank') do
  # Store the current count before attempting to create an invalid teacher
  @before_invalid_attempt_count = Teacher.count
  # Clear form fields
  fill_in 'Name', with: ''
  fill_in 'Email', with: ''
end

Then('I should see error messages') do
  expect(page).to have_content('The following errors prevented the teacher from being saved')
  expect(page).to have_content("Name can't be blank")
  expect(page).to have_content("Email can't be blank")
end

Then('the teacher should not be added') do
  current_count = Teacher.count
  # Compare with the count before the invalid attempt
  expected_count = @before_invalid_attempt_count || @initial_teacher_count
  expect(current_count).to eq(expected_count)
end

# capture the initial count of teachers before scenarios
Before do
  @initial_teacher_count = Teacher.count
end

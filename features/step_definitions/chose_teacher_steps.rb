# features/step_definitions/teacher_steps.rb

Given('I am on Settings Page') do
  # Create a semester first
  semester = Semester.find_or_create_by!(name: 'Fall 2024', active: true)

  @student = Student.find_or_create_by!(
    email: 'test_student@tamu.edu',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789',
    semester_id: semester.id
  )

  login_as_student

  # Then visit settings page
  visit '/settings'
end

Then('I should see a dropdown input that allows me to select a teacher to link my account to.') do
  expect(page).to have_selector('select')
end

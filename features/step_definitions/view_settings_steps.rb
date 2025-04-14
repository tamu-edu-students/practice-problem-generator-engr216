Given('I am on the student dashboard and I am logged in as a student') do
  # Create a semester first
  semester = Semester.find_or_create_by!(name: 'Fall 2024', active: true)

  @student = Student.find_or_create_by!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789',
    semester_id: semester.id
  )
  login_as_student
  visit practice_problems_path
end

Then('I should see a settings button.') do
  # Check that the 'Settings' link is present on the page
  expect(page).to have_link('Settings')
end

When('I click the settings button') do
  click_link('Settings') # Click the link with the text 'Settings'
end

Then('I should be on a page where I can see and edit my settings.') do
  expect(page).to have_current_path('/settings')
end

Given('I am on the student settings page and I am logged in as a student') do
  # Create a semester first
  semester = Semester.find_or_create_by!(name: 'Fall 2024', active: true)

  @student = Student.find_or_create_by!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789',
    semester_id: semester.id
  )
  login_as_student
  visit '/settings'
end

Then('I should see a Problem Select button.') do
  expect(page).to have_link('Problem Select')
end

When('I click the Problem Select button') do
  click_link('Problem Select')
end

Then('I should be on the student dashboard.') do
  expect(page).to have_current_path('/practice_problems')
end

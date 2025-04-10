Given('I am logged in as a student on settings test') do
  teacher = Teacher.find_or_create_by(name: 'Jordan Daryanani', email: 'jordandary@tamu.edu')
  student = Student.find_or_create_by(email: 'test_student@tamu.edu') do |s|
    s.first_name = 'Test'
    s.last_name = 'Student'
    s.uin = 123_456_789
    s.teacher_id = teacher.id
    s.semester = 'Fall 2024'
    s.authenticate = false
  end
  page.set_rack_session(user_id: student.id)
end

Given('I am on my profile or settings page') do
  visit settings_path
end

When('I view my profile') do
  visit settings_path
end

Then('I should see the {string} field') do |field_label|
  expect(page).to have_content(field_label)
end

Then('I should be able to save my profile without filling it in') do
  click_button 'Save Settings'
  expect(page).to have_content('Settings updated successfully!')
end

Then('I should be able to save my profile without entering an email') do
  # Email is shown as plain text, not input, so nothing to fill in
  click_button 'Save Settings'
  expect(page).to have_content('Settings updated successfully!')
end

When('I change my assigned teacher from the dropdown') do
  select 'Jordan Daryanani', from: 'student_teacher_id'
end

When('I click {string}') do |button_text|
  click_button button_text
end

Then('my new teacher should be saved in the system') do
  expect(page).to have_content('Settings updated successfully!')
end

When('I select a different semester from the dropdown') do
  select 'Fall 2025', from: 'student_semester'
end

Then('my new semester should be saved in the system') do
  expect(page).to have_content('Settings updated successfully!')
end

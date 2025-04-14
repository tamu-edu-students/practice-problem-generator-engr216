Given('I am logged in as a student on settings test') do
  teacher = Teacher.find_or_create_by(name: 'Jordan Daryanani', email: 'jordandary@tamu.edu')

  # Create a semester first
  semester = Semester.find_or_create_by(name: 'Fall 2024') do |s|
    s.active = true
  end

  student = Student.find_or_create_by(email: 'test_student@tamu.edu') do |s|
    s.first_name = 'Test'
    s.last_name = 'Student'
    s.uin = 123_456_789
    s.teacher_id = teacher.id
    s.semester_id = semester.id # Use semester_id instead of semester string
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
  # Debug information
  puts "Available semesters: #{Semester.pluck(:name).join(', ')}"

  # Get the semester dropdown
  semester_select = find('select[name="student[semester_id]"]')
  available_options = semester_select.all('option').map(&:text).reject(&:empty?)
  puts "Available options in the dropdown: #{available_options.join(', ')}"

  # Get the current selected option
  begin
    current_selected = semester_select.find('option[selected]')&.text
  rescue StandardError
    current_selected = nil
  end
  puts "Currently selected: #{current_selected}"

  # Select any option that's different from the current one
  option_to_select = available_options.reject { |opt| opt == current_selected }.first
  puts "Selecting option: #{option_to_select}"

  # Select the option
  semester_select.select(option_to_select)
end

Then('my new semester should be saved in the system') do
  expect(page).to have_content('Settings updated successfully!')
end

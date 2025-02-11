Given('I am on the teacher dashboard') do
  Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') do |teacher|
    teacher.first_name = 'test'
    teacher.last_name  = 'teacher'
  end

  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                       uid: '123',
                                                                       provider: 'google_oauth2',
                                                                       info: {
                                                                         email: 'test_teacher@tamu.edu',
                                                                         first_name: 'test',
                                                                         last_name: 'teacher'
                                                                       }
                                                                     })
  visit '/auth/google_oauth2/callback?state=teacher'
end

When('I click student management') do
  click_link 'Student Management'
end

Then('I should be on the student management page') do
  expect(page).to have_content('Manage Students')
end

Given('I am on the student management page') do
  Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') do |teacher|
    teacher.first_name = 'test'
    teacher.last_name  = 'teacher'
  end

  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                       uid: '123',
                                                                       provider: 'google_oauth2',
                                                                       info: {
                                                                         email: 'test_teacher@tamu.edu',
                                                                         first_name: 'test',
                                                                         last_name: 'teacher'
                                                                       }
                                                                     })

  Student.find_or_create_by!(
    first_name: 'John',
    last_name: 'Doe',
    uin: '123456789'
  )

  visit '/auth/google_oauth2/callback?state=teacher'
end

Then('I should see all of the students') do
  visit manage_students_path
  expect(page).to have_content('John Doe')
  expect(page).to have_content('123456789')
end

When('I click on a student') do
  click_link 'Student Management'
  student_row = find('tr', text: 'John Doe')
  within(student_row) do
    click_link 'Show'
  end
end

Then('I should see their information') do
  expect(page).to have_content('First name: John')
  expect(page).to have_content('Uin: 123456789')
end

Then('I should be able to edit their information') do
  click_link 'Edit this student'
  fill_in 'First name', with: 'Jane'
  fill_in 'Last name', with: 'Smith'
  fill_in 'Uin', with: '987654321'
  click_button 'Update Student'
  expect(page).to have_content('Student was successfully updated.')
end

Given('I am on the teacher dashboard') do
  Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') do |teacher|
    teacher.name = 'Test Teacher'
  end

  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                       uid: '123',
                                                                       provider: 'google_oauth2',
                                                                       info: {
                                                                         email: 'test_teacher@tamu.edu',
                                                                         first_name: 'Test'
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

Given('I am on the teacher student management page') do
  Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') do |teacher|
    teacher.name = 'Test Teacher'
  end

  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                       uid: '123',
                                                                       provider: 'google_oauth2',
                                                                       info: {
                                                                         email: 'test_teacher@tamu.edu',
                                                                         first_name: 'Test',
                                                                         last_name: 'Teacher'
                                                                       }
                                                                     })

  Student.find_or_create_by!(
    email: 'john.doe@example.com',
    first_name: 'John',
    last_name: 'Doe',
    uin: 123_456_789
  )

  visit '/auth/google_oauth2/callback?state=teacher'
end

Then('I should see all of the students') do
  visit manage_students_path

  # Get the teacher (should already exist from Given step)
  teacher = Teacher.find_by(email: 'test_teacher@tamu.edu')

  # Clean up any existing student with this email to avoid conflicts
  existing_student = Student.find_by(email: 'john.doe@example.com')
  existing_student&.destroy

  # Now create a new student
  Student.create!(
    email: 'john.doe@example.com',
    first_name: 'John',
    last_name: 'Doe',
    uin: 123_456_789,
    teacher: teacher
  )

  # Reload the page to see the new student
  visit manage_students_path

  expect(page).to have_content('John Doe')
end

When('I click on a student') do
  # First make sure we're on the manage students page
  visit manage_students_path

  # Get the teacher (should already exist from Given step)
  teacher = Teacher.find_by(email: 'test_teacher@tamu.edu')

  # Clean up any existing student with this email to avoid conflicts
  existing_student = Student.find_by(email: 'jane.smith@example.com')
  existing_student&.destroy

  # Create a different student to avoid email conflicts
  student = Student.create!(
    email: 'jane.smith@example.com',
    first_name: 'Jane',
    last_name: 'Smith',
    uin: 987_654_321,
    teacher: teacher
  )

  # Now go to the student's show page directly
  visit student_path(student)
end

Then('I should see their information') do
  expect(page).to have_content('First name: Jane')
  expect(page).to have_content('Last name: Smith')
end

Then('I should be able to edit their information') do
  click_link 'Edit this student'
  fill_in 'First name', with: 'Jane'
  fill_in 'Last name', with: 'Smith'
  fill_in 'Uin', with: '987654321'
  click_button 'Update Student'
  expect(page).to have_content('Student was successfully updated.')
end

Given('I am on the log in page') do
  visit login_path
end

When('I log in as a teacher') do
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

Then('I should be on the teacher dashboard') do
  expect(page).to have_content('Student Management')
end

Given('I am not logged in') do
  visit('/logout')
end

When('I navigate to the teacher dashboard link') do
  visit teacher_dashboard_path
end

Then('I should not be on the teacher dashboard') do
  expect(page).to have_content('Login')
end

Given('I am on the log in page') do
  visit root_path
end

When('I log in as a teacher') do
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
  visit '/auth/google_oauth2/callback?state=teacher'
end

Then('I should be on the teacher dashboard') do
  expect(page).to have_content('Student Management')
end

Given('I am not logged in') do
  visit '/logout'
end

When('I navigate to the teacher dashboard link') do
  visit teacher_dashboard_path
end

Then('I should not be on the teacher dashboard') do
  expect(page).not_to have_content('Teacher Dashboard')
end

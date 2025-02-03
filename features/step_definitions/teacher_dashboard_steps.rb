Given('I am on the log in page') do
  visit root_path
end

When('I log in as a teacher') do
  visit '/auth/google_oauth2/callback?state=teacher'
end

Then('I should be on the teacher dashboard') do
  expect(page).to have_content('Teacher Dashboard')
end

Given('I am not logged in') do
  visit logout_path
end

When('I navigate to the teacher dashboard link') do
  visit teacher_dashboard_path
end

Then('I should not be on the teacher dashboard') do
  expect(page).to have_content('Login')
end

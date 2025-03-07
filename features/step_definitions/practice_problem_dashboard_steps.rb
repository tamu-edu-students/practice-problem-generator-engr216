Given('I am on the log in page as a student') do
  Student.find_or_create_by!(
    email: 'test_student@tamu.edu'
  ) do |student|
    student.first_name = 'test'
    student.last_name = 'student'
    student.uin = '123456789'
  end
  visit root_path
end

When('I log in as a student') do
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                       uid: '123',
                                                                       provider: 'google_oauth2',
                                                                       info: {
                                                                         email: 'test_student@tamu.edu',
                                                                         first_name: 'test',
                                                                         last_name: 'student'
                                                                       }
                                                                     })
  visit '/auth/google_oauth2/callback?state=student'
end

Then('I should be on the practice problems.') do
  expect(page).to have_content('Select Category')
end

Given('I am not logged in as a student') do
  visit '/logout'
  if Capybara.current_session.driver.respond_to?(:browser)
    Capybara.current_session.driver.browser.manage.delete_all_cookies
  end
end

When('I navigate to the dashboard link') do
  visit practice_problems_path
end

Then('I should not be on the problem dashboard') do
  # Verify that the user was redirected (for example, to the root_path)
  # and thus does not see the dashboard text "Select Category"
  expect(current_path).not_to eq(practice_problems_path)
  expect(page).to have_content('You must be logged in as a student')
end

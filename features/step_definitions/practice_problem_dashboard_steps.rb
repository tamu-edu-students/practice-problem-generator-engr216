Given('I am on the log in page as a student') do
  @teacher = Teacher.find_or_create_by!(email: 'test_student@tamu.edu') { |t| t.name = 'Test TStudent' }
  visit root_path
end

When('I log in as a student') do
  login_as_student
  visit practice_problems_path
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
  expect(page).to have_content('Please log in as a student') # Match the alert
  expect(page).not_to have_content('Select Category')
end

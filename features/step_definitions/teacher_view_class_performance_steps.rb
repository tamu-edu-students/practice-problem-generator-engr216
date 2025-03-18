require 'capybara' # Ensure Capybara is required

def login_as_teacher
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    uid: '123',
    provider: 'google_oauth2',
    info: {
      email: 'test_teacher@tamu.edu',
      first_name: 'Test',
      last_name: 'Teacher'
    }
  )
  visit '/auth/google_oauth2/callback?state=teacher'
end

Given('I am on the Teacher Dashboard page') do
  @teacher = Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') { |t| t.name = 'Test Teacher' }
  login_as_teacher

  # Visit the page
  visit teacher_dashboard_path
  expect(current_path).to eq(teacher_dashboard_path)
end

When('I click Show Classroom button') do
  click_link 'Student Problem History'
end

Then('I should be brought to a page for an overview of my classroom') do
  expect(current_path).to eq(student_history_dashboard_path)
end

Given('I am on the Classroom Performance Page') do
  @teacher = Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') { |t| t.name = 'Test Teacher' }
  login_as_teacher

  # Visit the page
  visit student_history_dashboard_path
  expect(current_path).to eq(student_history_dashboard_path)
end

Then('I should be able to view the Classroom cumulative scores for problem types') do
  expect(page).to have_content('Class Performance')
end

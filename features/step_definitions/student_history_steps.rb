def login_as_teacher
  visit root_path
  @teacher = Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') do |teacher|
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

Given('I am on the Teacher Dashboard page') do
  login_as_teacher
  visit teacher_dashboard_path
  # puts "Page content: #{page.body}" # Uncomment for debugging if needed
end

When('I click the {string} button') do |button_text|
  click_link button_text
end

Then('I should be brought to the student statistics page') do
  expect(page).to have_current_path(teacher_dashboard_student_statistics_path)
end

Given('I am on the student statistics page') do
  login_as_teacher
  @student = Student.find_or_create_by!(email: 'test_student@tamu.edu') do |student|
    student.first_name = 'Test'
    student.last_name = 'Student'
    student.uin = '123456789'
    student.teacher_id = @teacher.id
  end
  visit teacher_dashboard_student_statistics_path
  # puts "Stats page content: #{page.body}" # Uncomment for debugging if needed
end

When('I click on a student’s name') do
  click_link "#{@student.first_name} #{@student.last_name}"
end

Then('I should see a summary of the student\'s past problems') do
  category = Category.find_or_create_by!(name: 'Math')
  StudentCategoryStatistic.create!(
    student_id: @student.id,
    category_id: category.id,
    attempts: 2,
    correct_attempts: 1
  )
  visit teacher_dashboard_student_statistics_show_path(@student)
  # Check for the summary text, ignoring HTML tags
  expect(page).to have_content('Total problems: 2')
  expect(page).to have_content('Correct: 1')
  expect(page).to have_content('Incorrect: 1')
end
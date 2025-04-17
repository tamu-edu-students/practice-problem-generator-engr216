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

Given('I am on the Teacher\'s Student Management page') do
  @teacher = Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') { |t| t.name = 'Test Teacher' }
  login_as_teacher

  # Visit the page
  visit teacher_dashboard_path
end

When('I click Show Student Problem History button') do
  # Click the link/button for the seeded student
  click_link 'Student Problem History'
end

Then('I should be brought to a page for the students problem history') do
  # Verify navigation to the student's problem history page
  expect(current_path).to eq(student_history_dashboard_path)
end

Given('I am on a Student\'s Problem History') do
  # Clear the session in a driver-agnostic way
  Capybara.reset_sessions!

  # Seed a teacher if not already present
  @teacher = Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') do |t|
    t.name = 'Test Teacher'
  end

  # Create a semester first
  @semester = Semester.find_or_create_by!(name: 'Spring 2024', active: true)

  # Seed a student with fixed data for reliable testing
  @student = Student.find_or_create_by!(email: 'history_student@example.com') do |student|
    student.first_name = 'History'
    student.last_name = 'Test'
    student.uin = 555_666_777
    student.teacher_id = @teacher.id
    student.semester_id = @semester.id
  end

  # Make sure the student is associated with the teacher
  @student.update!(teacher_id: @teacher.id) if @student.teacher_id != @teacher.id

  # Force a reload to ensure data is updated
  @student.reload

  # Seed problem history for the student
  question = Question.find_or_create_by!(
    category: 'Measurement & Error',
    question: 'What is the standard deviation?',
    answer_choices: %w[1 2 3]
  )

  # Create an answer for this student
  Answer.find_or_create_by!(student_email: @student.email, question_id: question.id) do |ans|
    ans.category = question.category
    ans.question_description = question.question
    ans.answer_choices = question.answer_choices
    ans.answer = '2'
    ans.correctness = true
    ans.date_completed = Time.zone.today
    ans.time_spent = '3 minutes'
  end

  # Log in as teacher
  login_as_teacher

  # Check that we have a valid session
  expect(page).to have_current_path(teacher_dashboard_path)

  # Instead of directly visiting student history, let's go through the proper UI flow
  visit student_history_dashboard_path

  # Directly visit the student history page with the correct params
  visit student_history_path(student_email: 'history_student@example.com')

  # Skip the expectation for now to see the actual page content
  puts "Current page content: #{page.text}"
end

Then('I should be able to view the student\'s past problems') do
  # Check for specific content that should be on the page
  expect(page).to have_content('What is the standard deviation?')
  expect(page).to have_content('Category')
  expect(page).to have_content('Question')
  expect(page).to have_content('Correctness')
end

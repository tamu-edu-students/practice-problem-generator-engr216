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
  # Verify navigation to the student’s problem history page
  expect(current_path).to eq(student_history_dashboard_path)
end

Given('I am on a Student\'s Problem History') do
  # Seed a teacher if not already present
  @teacher = Teacher.find_or_create_by!(email: 'test_teacher@tamu.edu') do |t|
    t.name = 'Test Teacher'
  end

  # Seed a student with random data, matching your seeding method
  @student = Student.find_or_create_by!(email: Faker::Internet.email) do |student|
    student.first_name = Faker::Name.first_name
    student.last_name = Faker::Name.last_name
    student.uin = Faker::Number.unique.number(digits: 9).to_i
    student.teacher = @teacher
    student.authenticate = [true, false].sample
  end

  # Seed problem history for the student
  question = Question.find_or_create_by!(
    category: 'Measurement & Error',
    question: 'What is 2 + 2?',
    answer_choices: %w[4 5 6]
  )
  Answer.create!(
    question_id: question.id,
    category: question.category,
    question_description: question.question,
    answer_choices: question.answer_choices,
    answer: '4',
    correctness: true,
    student_email: @student.email,
    date_completed: Faker::Date.backward(days: 30),
    time_spent: '5 minutes'
  )

  login_as_teacher
  # Visit the student's problem history page
  visit student_history_path(uin: @student.uin)
  expect(current_path).to eq(student_history_path(uin: @student.uin))
end

Then('I should be able to view the student\'s past problems') do
  expect(page).to have_content('What is 2 + 2')
end

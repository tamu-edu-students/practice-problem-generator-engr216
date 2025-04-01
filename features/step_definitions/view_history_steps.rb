def login_as_student
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    uid: '123',
    provider: 'google_oauth2',
    info: {
      email: 'test_student@tamu.edu',
      first_name: 'Test',
      last_name: 'Student',
      uin: '123456789'
    }
  )
  visit '/auth/google_oauth2/callback?state=student'
end

Given('I am on the student dashboard') do
  @student = Student.find_or_create_by!(email: 'test_student@tamu.edu') do |s|
    s.first_name = 'Test'
    s.last_name = 'Student'
    s.uin = '123456789'
  end
  login_as_student
  visit '/practice_problems'
end

When('I select the history button') do
  expect(page).to have_button('Past Problems')
end

Then('I should be on the history page') do
  visit '/history'
end

Given('I am on the history page') do
  @student = Student.find_or_create_by!(email: 'test_student@tamu.edu') do |s|
    s.first_name = 'Test'
    s.last_name = 'Student'
    s.uin = '123456789'
  end
  login_as_student

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
  visit '/history'
end

Then('I should see problems I have done') do
  expect(page).to have_text('Question')
end

Then('I should see how I did on them') do
  expect(page).to have_text('Your Answer')
end

When('I click the Problem Select button on the history page') do
  click_link('Problem Select')
end

Then('I should be on the student dashboard') do
  visit '/practice_problems'
end

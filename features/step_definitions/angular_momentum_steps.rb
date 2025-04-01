Given('I am on the "Angular Momentum" page for momentum') do
  @student = Student.create!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789'
  )
  page.set_rack_session(user_id: @student.id)
  visit generate_angular_momentum_problems_path
end

When('I click the "new problem" button') do
  click_link_or_button('Generate New Problem')
end

When('I submit an answer') do
  # First ensure a problem is present
  step 'I click the "new problem" button'

  # Wait for inputs to appear
  sleep(1)

  if page.has_field?('am_answer', wait: 5)
    fill_in 'am_answer', with: '12.0'
  elsif page.has_field?('am_answer_1', wait: 5) && page.has_field?('am_answer_2', wait: 5)
    fill_in 'am_answer_1', with: '1.234'
    fill_in 'am_answer_2', with: '2.345'
  else
    # Fall back to any visible text input fields
    inputs = page.all('input[type="text"]')
    raise 'No input fields found for angular momentum answer' unless inputs.any?

    inputs.each { |input| input.set('1.234') }
  end

  click_button 'Check Answer'
end

Then('a new "Angular Momentum" problem should be dynamically generated for momentum') do
  expect(page).to have_content('Angular Momentum Question:')
end

Then('I should receive feedback on my angular momentum answer') do
  expect(page).to have_content(/Correct, the answer .* is right!|Incorrect, the correct answer is .*/)
end

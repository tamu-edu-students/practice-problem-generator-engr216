Given('I am on the "Angular Momentum" page for momentum') do
  @student = Student.find_or_create_by!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789'
  )
  login_as_student
  visit generate_practice_problems_path(category_id: 'Angular Momentum')
end

When('I click the "new problem" button') do
  click_link 'Generate New Problem'
end

When('I submit an answer') do
  # Wait for inputs to appear
  sleep(1)

  if page.has_field?('answer', wait: 5)
    fill_in 'answer', with: '12.0'
  elsif page.has_field?('answer_1', wait: 5) && page.has_field?('answer_2', wait: 5)
    fill_in 'answer_1', with: '1.234'
    fill_in 'answer_2', with: '2.345'
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

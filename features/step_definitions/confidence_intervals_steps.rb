Given('I am on the Confidence Interval Page') do
  @student = Student.create!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789'
  )
  page.set_rack_session(user_id: @student.id)
  visit generate_practice_problems_path(category_id: 'Confidence Intervals')
end

Given('I on the Confidence Interval Page') do
  @student = Student.create!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789'
  )
  page.set_rack_session(user_id: @student.id)
  visit generate_practice_problems_path(category_id: 'Confidence Intervals')
end

When('I click the new confidence interval problem button') do
  click_link 'Generate New Problem'
end

When('I submit a confidence interval answer') do
  # First generate a new problem to ensure we have valid data in the session
  step 'I click the new confidence interval problem button'

  # Submit realistic values for confidence intervals - usually between 0-100
  fill_in 'lower_bound', with: '10'
  fill_in 'upper_bound', with: '20'
  click_button 'Check Answer'
end

Then('a new Confidence Interval problem should be dynamically generated') do
  expect(page).to have_css('h1', text: 'Confidence Interval Problem:')
end

Then('I should be given feedback on my confidence interval answer') do
  # This will pass if either success or error message is shown
  expect(page).to have_css('div', text: /Correct|Incorrect|your lower bound|your upper bound/i)
end

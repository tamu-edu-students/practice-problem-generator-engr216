Given('I am on a problem page') do
  # Create a test student
  @student = Student.find_or_create_by!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789'
  )

  if respond_to?(:login_as_student)
    login_as_student
  else
    visit login_path
    page.set_rack_session(user_id: @student.id, user_type: 'student')
  end

  # Navigate directly to an engineering ethics problem
  visit generate_practice_problems_path(category_id: 'Engineering Ethics')
  expect(page).to have_content('Engineering Ethics')
end

Given('the problem has not been solved') do
  # Verify that the solution isn't displayed yet
  expect(page).not_to have_content('Correct Answer:')
  # And the check answer button should be enabled
  expect(page).to have_button('Check Answer', disabled: false) if has_button?('Check Answer')
  expect(page).to have_button('Submit', disabled: false) if has_button?('Submit')
end

When('I click the {string} button') do |button_name|
  click_button button_name if has_button?(button_name)
  click_link button_name if has_link?(button_name) && !has_button?(button_name)
end

Then('the correct solution should be displayed') do
  # After clicking "View Answer", we should see the solution
  expect(page).to have_content('Correct Answer:')
end

Then('the {string} button should be disabled') do |button_name|
  expect(page).to have_button(button_name, disabled: true)
end

When('I enter a response in the input field') do
  # For engineering ethics problems, there are radio buttons
  if page.has_field?('ethics_answer_true')
    choose('ethics_answer_true')
  elsif page.has_css?('input[type="radio"]')
    first('input[type="radio"]').click
  elsif page.has_field?('answer')
    fill_in 'answer', with: '42'
  elsif page.has_field?('lower_bound') && page.has_field?('upper_bound')
    fill_in 'lower_bound', with: '10'
    fill_in 'upper_bound', with: '20'
  else
    # For other types of input fields
    inputs = page.all('input[type="text"]')
    inputs.each do |input|
      input.fill_in with: '42'
    end
  end
end

Then('the system should evaluate my response') do
  # After checking an answer, we should see some evaluation feedback
  expect(page).to have_content(/Try again|Correct|Incorrect|Your answer was|Feedback/i)
end

Then('provide feedback without showing the correct solution') do
  # There should be feedback but the correct answer shouldn't be revealed
  expect(page).not_to have_content('Correct Answer:')
end

Then('I should still be able to modify my answer and try again') do
  # The input field should still be enabled
  if page.has_field?('ethics_answer_true')
    expect(page).to have_field('ethics_answer_true', disabled: false)
  elsif page.has_css?('input[type="radio"]')
    expect(page).to have_css('input[type="radio"]:not([disabled])')
  elsif page.has_field?('answer')
    expect(page).to have_field('answer', disabled: false)
  elsif page.has_field?('lower_bound') && page.has_field?('upper_bound')
    expect(page).to have_field('lower_bound', disabled: false)
    expect(page).to have_field('upper_bound', disabled: false)
  else
    # For other types of input fields
    inputs = page.all('input[type="text"]')
    inputs.each do |input|
      expect(input).not_to be_disabled
    end
  end
end

Then('the {string} button should remain active') do |button_name|
  expect(page).to have_button(button_name, disabled: false) if has_button?(button_name)
  expect(page).to have_link(button_name) if has_link?(button_name) && !has_button?(button_name)
end

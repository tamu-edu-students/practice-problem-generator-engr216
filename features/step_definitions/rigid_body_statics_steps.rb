# features/step_definitions/rigid_body_statics_steps.rb

Given('I am on the {string} page') do |page_name|
  @student = Student.create!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789'
  )
  page.set_rack_session(user_id: @student.id)
  case page_name
  when 'Rigid Body Statics'
    visit generate_rigid_body_statics_problems_path
  else
    raise "Unknown page: #{page_name}"
  end
end

When('I click the {string} button') do |_button_text|
  click_link_or_button('New Problem')
end

Then('a new {string} problem should be dynamically generated') do |category|
  # Check that the page contains a question from the given category.
  expect(page).to have_content(category)
  # Verify that some question text is visible (this selector depends on your view markup)
  expect(page).to have_css('p.text-xl', minimum: 1)
end

When('I submit a Rigid Body Statics answer') do
  if page.has_field?('rbs_answer', wait: 5)
    fill_in 'rbs_answer', with: '1.234'
  elsif page.has_field?('rbs_answer_1', wait: 5) && page.has_field?('rbs_answer_2', wait: 5)
    fill_in 'rbs_answer_1', with: '1.234'
    fill_in 'rbs_answer_2', with: '1.234'
  else
    inputs = page.all('input[type="text"]')
    raise 'No input fields found for rigid body statics answer' unless inputs.any?

    inputs.each { |input| input.set('1.234') }
  end

  click_button 'Check Answer'
end

Then('I should receive feedback on my Rigid Body Statics answer') do
  # Check that a feedback message is displayed, assuming it uses a border class for color.
  expect(page).to have_content(/Correct, the answer .* is right!|Incorrect, the correct answer is .*/)
end

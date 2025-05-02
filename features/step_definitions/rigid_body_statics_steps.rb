# features/step_definitions/rigid_body_statics_steps.rb

Given('I am on the {string} page for bodies') do |page_name|
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

When('I click the {string} button for bodies') do |_button_text|
  click_link_or_button('New Problem')
end

Then('a new {string} problem should be dynamically generated') do |category|
  # Check that the page contains a question from the given category.
  expect(page).to have_content(category)
  # Verify that some question text is visible (this selector depends on your view markup)
  expect(page).to have_css('p.text-xl', minimum: 1)
end

When('I submit a Rigid Body Statics answer') do
  max_attempts = 5
  attempts = 0

  # 1) Keep generating new problems until an answer field shows up (or we give up)
  loop do
    click_link_or_button('Generate New Problem')
    break if page.has_selector?('input[id^="rbs_answer"]', visible: true, wait: 3)

    attempts += 1
    raise "No RBS answer fields found after #{max_attempts} attempts" if attempts >= max_attempts
  end

  # 2) Grab all the visible, enabled inputs starting with "rbs_answer"
  elements = all('input[id^="rbs_answer"]', visible: true)
             .reject(&:disabled?)

  # 3) Fill or click each one
  elements.each do |el|
    if el[:type] == 'text'
      el.set('1.234')
    else
      el.click
    end
  end

  # 4) Finally submit
  click_button 'Check Answer'
end

Then('I should receive feedback on my Rigid Body Statics answer') do
  # Check that a feedback message is displayed, assuming it uses a border class for color.
  expect(page).to have_content(/Correct.*answer.*is right!|Incorrect.*try again.*View Answer/, wait: 5)
end

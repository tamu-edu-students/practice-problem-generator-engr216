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
  if page.has_selector?('input[type="radio"][name="rbs_answer"]', wait: 5)
    first('input[type="radio"][name="rbs_answer"]').click
  else
    text_fields = page.all('input[type="text"][name^="rbs_answer"]', wait: 5)
    raise 'No input fields found for rigid body statics answer' unless text_fields.any?

    text_fields.each_with_index do |field, index|
      field.set((1.234 + (index * 0.1)).round(3).to_s)
    end

  end
  click_button 'Check Answer'
end

Then('I should receive feedback on my Rigid Body Statics answer') do
  expect(page).to have_content(
    /Correct.*answer.*is right!|Incorrect.*try again.*View Answer|Incorrect, the correct answer is [A-D]\./, wait: 5
  )
end

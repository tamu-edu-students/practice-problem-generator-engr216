Given('I am on the "Particle Statics" page') do
  @student = Student.create!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789'
  )
  page.set_rack_session(user_id: @student.id)
  visit generate_particle_statics_problems_path
  expect(page).to have_content('Particle Statics')
end

When('I click the particle statics new problem button') do
  click_link_or_button('Generate New Problem')
end

When('I submit a particle statics answer') do
  # First ensure a problem is present
  step 'I click the particle statics new problem button'

  # Check for multiple-choice (radio buttons) first
  if page.has_selector?('input[type="radio"][name="ps_answer"]', wait: 5)
    # Select the first radio button option
    first('input[type="radio"][name="ps_answer"]').click
  else
    # Handle fill-in-the-blank (text fields)
    text_fields = page.all('input[type="text"][name^="ps_answer"]', wait: 5)
    raise 'No input fields found for particle statics answer' unless text_fields.any?

    text_fields.each_with_index do |field, index|
      # Fill with incremental test values (e.g., 1.234, 1.334, etc.)
      field.set((1.234 + (index * 0.1)).round(3).to_s)
    end

  end

  click_button 'Check Answer'
end

Then('a new "Particle Statics" problem should be dynamically generated for particles') do
  expect(page).to have_content('Particle Statics Question:')
end

Then('I should receive feedback on my particle statics answer') do
  expect(page).to have_content(
    /Correct.*answer.*is right!|Incorrect.*try again.*View Answer|Incorrect, the correct answer is [A-D]\./, wait: 5
  )
end

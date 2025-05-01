Given('I am on the Harmonic Motion Problem Generator page') do
  @student = Student.find_or_create_by!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789'
  )
  login_as_student
  visit generate_harmonic_motion_problems_path
  expect(page).to have_content('Harmonic Motion')
end

When('I click the New Problem button') do
  click_link_or_button('New Problem')
end

When('I submit a Harmonic Motion answer') do
  if page.has_selector?('input[type="radio"][name="shm_answer"]', wait: 5)
    # Multiple-choice question: select the first radio button
    first('input[type="radio"][name="shm_answer"]').click
  else
    # Fill-in-the-blank question: look for text fields
    text_fields = page.all('input[type="text"][name^="shm_answer"]', wait: 5)
    raise 'No input fields found for harmonic motion answer' unless text_fields.any?

    text_fields.each_with_index do |field, index|
      # Fill with incremental test values (e.g., 1.734, 1.834, etc.)
      field.set((1.734 + (index * 0.1)).round(3).to_s)
    end

  end

  click_button 'Check Answer'
end

Then('a new Harmonic Motion problem should be dynamically generated') do
  expect(page).to have_content('Harmonic Motion Question:')
end

Then('I should receive feedback on my Harmonic Motion answer') do
  expect(page).to have_content(
    /Correct.*answer.*is right!|Incorrect.*try again.*View Answer|Incorrect, the correct answer is [A-D]\./, wait: 5
  )
end

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

When('I click the "new particle statics problem" button') do
  click_link_or_button('Generate New Problem')
end

When('I submit a particle statics answer') do
  # First ensure a problem is present
  step 'I click the "new particle statics problem" button'

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
    raise 'No input fields found for particle statics answer' unless inputs.any?

    inputs.each { |input| input.set('1.234') }
  end

  click_button 'Check Answer'
end

Then('a new "Particle Statics" problem should be dynamically generated for particles') do
  expect(page).to have_content('Particle Statics Question:')
end

Then('I should receive feedback on my particle statics answer') do
  expect(page).to have_content(/Correct, the answer .* is right!|Incorrect, the correct answer is .*/)
end

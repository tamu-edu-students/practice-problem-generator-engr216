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
  max_attempts = 5
  attempts = 0

  # 1) Keep generating until we see a ps_answer field (or blow up)
  loop do
    click_link_or_button('Generate New Problem')
    break if page.has_selector?('input[id^="ps_answer"]', visible: true, wait: 3)

    attempts += 1
    raise "No Particle Statics answer fields found after #{max_attempts} attempts" if attempts >= max_attempts
  end

  # 2) Grab all visible, enabled ps_answer inputs
  elements = all('input[id^="ps_answer"]', visible: true)
             .reject(&:disabled?)

  if elements.any?
    # 3) Fill or click each element
    elements.each do |el|
      if el[:type] == 'text'
        el.set('1.234')
      else # radio
        el.click
      end
    end
  else
    # 4) Fallback to any visible text inputs
    fallback = all('input[type="text"]', visible: true)
               .reject(&:disabled?)
    raise 'No answer fields found for Particle Statics' if fallback.empty?

    fallback.each { |f| f.set('1.234') }
  end

  # 5) Submit
  click_button 'Check Answer'
end

Then('a new "Particle Statics" problem should be dynamically generated for particles') do
  expect(page).to have_content('Particle Statics Question:')
end

Then('I should receive feedback on my particle statics answer') do
  expect(page).to have_content(/Correct.*answer.*is right!|Incorrect.*try again.*View Answer/, wait: 5)
end

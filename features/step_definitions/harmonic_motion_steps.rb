# features/step_definitions/harmonic_motion_steps.rb

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
  max_attempts = 5
  attempts = 0

  # 1) Keep generating new problems until we see a shm_answer field (or fail)
  loop do
    click_link_or_button('Generate New Problem')
    break if page.has_selector?('input[id^="shm_answer"]', visible: true, wait: 3)

    attempts += 1
    raise "No Harmonic Motion answer fields found after #{max_attempts} attempts" if attempts >= max_attempts
  end

  # 2) Collect all visible, enabled shm_answer inputs
  elements = all('input[id^="shm_answer"]', visible: true)
             .reject(&:disabled?)

  if elements.any?
    # 3) Fill text fields or click radio buttons
    elements.each do |el|
      if el[:type] == 'text'
        el.set('1.734')
      else
        el.click
      end
    end
  else
    # 4) Fallback to any visible text inputs
    fallback = all('input[type="text"]', visible: true)
               .reject(&:disabled?)
    raise 'No answer fields found for Harmonic Motion' if fallback.empty?

    fallback.each { |f| f.set('1.734') }
  end

  # 5) Finally, submit
  click_button 'Check Answer'
end

Then('a new Harmonic Motion problem should be dynamically generated') do
  expect(page).to have_content('Harmonic Motion Question:')
end

Then('I should receive feedback on my Harmonic Motion answer') do
  expect(page).to have_content(/Correct.*answer.*is right!|Incorrect.*try again.*View Answer/, wait: 5)
end

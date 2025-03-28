# features/step_definitions/harmonic_motion_steps.rb

Given('I am on the Harmonic Motion Problem Generator page') do
  visit generate_harmonic_motion_problems_path
end

When('I click the New Problem button') do
  click_link_or_button('New Problem')
end

When('I submit a Harmonic Motion answer') do
  if page.has_field?('shm_answer', wait: 5)
    fill_in 'shm_answer', with: '1.734'
  elsif page.has_field?('shm_answer_1', wait: 5) && page.has_field?('shm_answer_2', wait: 5)
    fill_in 'shm_answer_1', with: '1.734'
    fill_in 'shm_answer_2', with: '0.403'
  else
    raise 'No input field found for harmonic motion answer'
  end

  click_button 'Check Answer'
end

Then('a new Harmonic Motion problem should be dynamically generated') do
  expect(page).to have_content('Harmonic Motion Question:')
end

Then('I should receive feedback on my Harmonic Motion answer') do
  expect(page).to have_content(/Correct, the answer .* is right!|Incorrect, the correct answer is .*/)
end

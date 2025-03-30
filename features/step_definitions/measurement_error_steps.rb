Given('I am on the measurement and error page') do
  # Ensure that this URL renders the measurement & error view.
  visit generate_practice_problems_path(category_id: 'Measurements and Error')
end

When('I click the measurement error {string} button') do |button_text|
  click_link_or_button button_text
end

When('I select a measurement answer and submit the form') do
  # Check if there are any radio buttons
  if page.has_css?("input[type='radio']", wait: 5)
    first("input[type='radio']").click
  elsif page.has_field?('measurement_answer')
    # If not, then assume it's a fill-in question. For testing, use the correct answer.
    # Note: In a real test you might decide to simulate a wrong answer.
    fill_in 'measurement_answer', with: find_field('measurement_answer')[:value] || 'TestAnswer'
  else
    raise 'No input field found for measurement_answer'
  end
  click_button 'Check Answer'
end

Then('a new measurement error problem should be dynamically generated') do
  # The view should display a header like "Error and Measurement Question:"
  expect(page).to have_content('Error and Measurement Question:')
end

Then('I should receive measurement feedback') do
  expect(page).to have_content(/Correct|Incorrect/)
end

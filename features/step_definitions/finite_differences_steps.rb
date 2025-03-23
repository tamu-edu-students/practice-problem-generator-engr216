Given('I am on the "Finite Differences" page') do
  visit practice_problems_path
  click_link "Finite Differences"
end

When('I click the "new problem" button') do
  click_link "Generate New Problem"
end

Then('a new "Finite Differences" problem should be dynamically generated') do
  expect(page).to have_content("Category: Finite Differences")
  expect(page).to have_content("Finite Differences Problem:")
end

When('I submit an answer') do
  # Find all input fields on the page
  input_fields = page.all('input[type="text"]')

  # Fill each input field with a value (42 for simplicity)
  input_fields.each do |field|
    # Skip hidden fields
    next if field[:type] == 'hidden'
    field.fill_in(with: '42')
  end
  
  click_button "Check Answer"
end

Then('I should receive feedback on my answer') do
  # Either success or error message should be displayed
  expect(page).to have_content("correct") || have_content("incorrect")
end 
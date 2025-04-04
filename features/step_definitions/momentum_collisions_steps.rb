# Step definitions for Momentum & Collisions feature

Given('I am on the "Momentum & Collisions" page for collision problems') do
  @student = Student.find_or_create_by!(
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'Student',
    uin: '123456789'
  )
  login_as_student
  visit generate_practice_problems_path(category_id: 'Momentum & Collisions')
end

When('I click the generate new problem button for collisions') do
  click_link_or_button 'Generate New Problem'
end

Then('a new {string} problem should be dynamically generated for collisions') do |problem_type|
  expect(page).to have_content(problem_type)
end

When('I submit an answer for collisions') do
  # Fill in the answer field with a sample value
  fill_in 'answer', with: '42'
  click_button 'Check Answer'
end

Then('I should receive feedback on my answer for collisions') do
  expect(page).to have_css('div', text: /Correct|Incorrect/)
end

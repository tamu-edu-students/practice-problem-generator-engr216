# features/step_definitions/teacher_steps.rb

Given('I am on Settings Page') do
  login_as_student
  visit '/settings'
end

Then('I should see a dropdown input that allows me to select a teacher to link my account to.') do
  expect(page).to have_selector('select')
end

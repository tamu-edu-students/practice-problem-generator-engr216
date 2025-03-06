# features/step_definitions/student_steps.rb

Given('I am on the Show Page for Individual Student Management') do
  # Create a student record. Adjust attributes as needed.
  @student = Student.create!(
    first_name: "Test",
    last_name: "Student",
    email: "test@example.com",
    uin: "123456789"
  )
  # Visit the update (edit) form for the created student.
  visit edit_student_path(@student)
end


When('I click the Back button') do
  # Assumes the back button is rendered with the text "←"
  click_link('←')
end

Then('I should be brought back to the Student Management Page') do
  visit manage_students_path 
end

Given('I am on the Student Management Page') do
  @student = Student.create!(
    first_name: "Test",
    last_name: "Student",
    email: "test@example.com",
    uin: "123456789"
  )
  # Visit the update (edit) form for the created student.
  visit edit_student_path(@student)
end


When('I click the Back button on this page') do
  # Again assuming the back button is rendered with "←"
  click_link('←')
end

Then('I should be brought back to the Teacher dashboard') do
  # Adjust teacher_dashboard_path if your route is different.
  visit manage_students_path 
end

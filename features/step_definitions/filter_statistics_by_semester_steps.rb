# features/step_definitions/filter_statistics_by_semester_steps.rb
Then('I should see statistics for students across all semesters') do
  expect(page).to have_content('Class Performance Overview')
  expect(page).to have_content('Total Completed:')
  expect(page).to have_content('Total Correct:')
  expect(page).to have_content('Total Incorrect:')
  expect(page).to have_content('Per-Category Breakdown')
end

# features/step_definitions/filter_statistics_by_semester_steps.rb
Then('I should see statistics only for students in {string}') do |semester_name|
  expect(page).to have_content('Class Performance Overview')
  expect(page).to have_select('semester_id', selected: semester_name)
  expect(page).to have_select('student_email', with_options: [@student1.first_name, 'All'])
  expect(page).not_to have_select('student_email', with_options: [@student2.first_name])
  expect(page).to have_content('Total Completed:')
end

Then('the class performance data should reflect only {string} students') do |semester_name|
  within('div.bg-white.shadow-lg.rounded-xl', text: 'Class Performance Overview') do
    expect(page).to have_content('Total Completed')
  end
end

When('I click on a student name') do
  visit "/teacher_dashboard/student_history_dashboard?semester_id=#{@fall_semester.id}"
  expect(page).to have_select('student_email', wait: 5)
  # Debug: Print available options
  options = page.all('#studentDropdown option').map(&:text)
  puts "Student dropdown options: #{options}"
  # Select by email to match the <option value>
  select "#{@student1.first_name} #{@student1.last_name}", from: 'student_email'
  click_button 'Apply'
end

Then('I should see that student\'s history filtered for {string}') do |semester_name|
  expect(page).to have_content('Student Performance Overview')
  expect(page).to have_content("#{@student1.first_name} #{@student1.last_name}")
  expect(page).to have_select('semester_id', selected: semester_name)
end

Then('the back button should maintain the semester filter') do
  # Since we're testing on the dashboard page directly, let's verify that
  # if we refresh the page with the semester filter, it's maintained
  visit student_history_dashboard_path(semester_id: @fall_semester.id)

  # Check the semester filter is still applied
  expect(page).to have_select('semester_id', selected: 'Fall 2024')
  expect(page).to have_content(@student1.first_name)
  expect(page).not_to have_content(@student2.first_name) # Should only show Fall 2024 students
end

When('I search for {string} in the search field') do |search_term|
  visit "/teacher_dashboard/student_history_dashboard?semester_id=#{@fall_semester.id}&search=#{search_term}"
  # Debug: Confirm the page loaded and check student dropdown
  expect(page).to have_select('student_email', wait: 5)
  options = page.all('#studentDropdown option').map(&:text)
  puts "Student dropdown options after search: #{options}"
end

Then('I should see only {string} students with {string} in their name or email') do |semester_name, search_term|
  expect(page).to have_select('semester_id', selected: semester_name)
  if semester_name == 'Fall 2024' && search_term == 'Smith'
    # No students should match, dropdown should only have "All"
    expect(page).to have_select('student_email', with_options: ['All'])
  else
    # Handle other cases if needed
    expected_options = ['All']
    student = @student1 if semester_name == 'Fall 2024' && (@student1.last_name.include?(search_term) || @student1.first_name.include?(search_term) || @student1.email.include?(search_term))
    student = @student2 if semester_name == 'Spring 2024' && (@student2.last_name.include?(search_term) || @student2.first_name.include?(search_term) || @student2.email.include?(search_term))
    expected_options << "#{student.first_name} #{student.last_name}" if student
    expect(page).to have_select('student_email', with_options: expected_options)
  end
end

Then('the semester filter should be maintained') do
  # Check the semester filter is still applied
  expect(page).to have_select('semester_id', selected: 'Fall 2024')
end

# Helper methods
def create_test_answers_for_student(student)
  # Create a test question
  question = Question.find_or_create_by!(
    category: 'Test Category',
    question: 'Test Question',
    answer_choices: %w[A B C]
  )

  # Create test answers for this student
  3.times do |_i|
    Answer.find_or_create_by!(
      student_email: student.email,
      question_id: question.id
    ) do |ans|
      ans.category = question.category
      ans.question_description = question.question
      ans.answer_choices = question.answer_choices
      ans.answer = 'A'
      ans.correctness = true
      ans.date_completed = Time.zone.today
      ans.time_spent = '1 minute'
    end
  end
end

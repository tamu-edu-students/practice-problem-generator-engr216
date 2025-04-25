# features/step_definitions/semester_steps.rb
Given('I am logged in as a teacher') do
  @teacher = Teacher.find_or_create_by!(email: 'teacher@tamu.edu') do |t|
    t.name = 'Test Teacher'
  end
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    provider: 'google_oauth2',
    uid: '456',
    info: {
      email: 'teacher@tamu.edu',
      name: 'Test Teacher'
    }
  )
  # Set session directly, bypassing callback
  page.set_rack_session(user_type: 'teacher', user_id: @teacher.id)
  visit teacher_dashboard_path
  puts "Teacher logged in: #{@teacher.email}"
end

Given('I am on the student management page') do
  @teacher ||= Teacher.find_by(email: 'teacher@tamu.edu') # Ensure teacher exists from previous step
  raise 'Teacher not found' unless @teacher

  # Use find_or_create_by! for Semesters
  @fall_semester = Semester.find_or_create_by!(name: 'Fall 2024') { |s| s.active = true }
  @spring_semester = Semester.find_or_create_by!(name: 'Spring 2024') { |s| s.active = true }

  # Use find_or_create_by! for Students, ensuring unique emails/UINs if needed
  # Using fixed UINs and emails for predictability
  @student1 = Student.find_or_create_by!(uin: 123_456_789) do |s|
    s.first_name = 'John'
    s.last_name = 'Doe'
    s.email = 'john.semester@example.com'
    s.teacher = @teacher
    s.semester = @fall_semester
  end
  # Ensure student1 is associated with the correct semester if found
  @student1.update!(semester: @fall_semester, teacher: @teacher) unless @student1.semester == @fall_semester

  @student2 = Student.find_or_create_by!(uin: 987_654_321) do |s|
    s.first_name = 'Jane'
    s.last_name = 'Smith'
    s.email = 'jane.semester@example.com'
    s.teacher = @teacher
    s.semester = @spring_semester
  end
  # Ensure student2 is associated with the correct semester if found
  @student2.update!(semester: @spring_semester, teacher: @teacher) unless @student2.semester == @spring_semester

  @student3 = Student.find_or_create_by!(uin: 456_789_123) do |s|
    s.first_name = 'Bob'
    s.last_name = 'Johnson'
    s.email = 'bob.semester@example.com'
    s.teacher = @teacher
    s.semester = nil # Explicitly set semester to nil
  end
  # Ensure student3 is associated with the correct semester if found
  @student3.update!(semester: nil, teacher: @teacher) unless @student3.semester.nil?

  visit manage_students_path
end

When('I select the {string} option') do |_option|
  # This option is implicitly selected by viewing the page with semesters loaded
  expect(page).to have_content('Filter by Semester')
end

Then('I should see students grouped under their respective semesters') do
  # Check that we have elements showing the different semesters
  expect(page).to have_select('semester_id', with_options: ['Fall 2024', 'Spring 2024'])
end

Given('students are grouped by semester') do
  # Students are already created in the background
  expect(Student.count).to be >= 2
  expect(Semester.count).to be >= 2
end

When('I select {string} from the semester dropdown') do |semester_name|
  if semester_name == 'All Semesters'
    select semester_name, from: 'semester_id'
    click_button 'Apply' if page.has_button?('Apply')
  else
    # Find the semester id - ensure semester exists
    semester = Semester.find_by(name: semester_name)
    raise "Semester '#{semester_name}' not found" unless semester

    select semester_name, from: 'semester_id'
    click_button 'Apply'
  end
end

Then('I should see only students enrolled in Fall {int}') do |_year|
  # Ensure student1 exists and is visible
  @student1 ||= Student.find_by(uin: 123_456_789)
  expect(page).to have_content(@student1.first_name)
  # Ensure student2 exists and is not visible
  @student2 ||= Student.find_by(uin: 987_654_321)
  expect(page).not_to have_content(@student2.first_name)
end

When('a student does not have a semester assigned') do
  # We already have a student without a semester from the background
  expect(@student3.semester).to be_nil
end

Then('they should appear under a {string} section') do |_section|
  # Ensure student3 exists and is visible
  @student3 ||= Student.find_by(uin: 456_789_123)
  expect(page).to have_content(@student3.first_name)
  within('table') do
    # Find the row containing the student's name
    student_row = find('tr', text: @student3.first_name)
    within(student_row) do
      # Check for 'Unknown' within that specific row
      expect(page).to have_content('Unknown')
    end
  end
end

Given('there are students in the {string} semester') do |semester_name|
  @semester = Semester.find_by(name: semester_name)
  expect(Student.where(semester: @semester).count).to be_positive
end

When('I click the "Drop All Students in {string}" button') do |semester_name|
  click_button "Drop All Students in #{semester_name}"
end

Then('all students in the {string} semester should be deleted') do |semester_name|
  # Check that the students in the specified semester have been deleted
  semester = Semester.find_by(name: semester_name)
  # Ensure the check is scoped to the current teacher's students
  expect(@teacher.students.where(semester: semester).count).to eq(0)
end

# features/step_definitions/semester_steps.rb (append to end)
Given('I have a semester named {string}') do |semester_name|
  @fall_semester = Semester.find_or_create_by!(name: semester_name) { |s| s.active = true }
end

# features/step_definitions/semester_steps.rb
Given('I have students enrolled in {string}') do |semester_name|
  @teacher ||= Teacher.find_by(email: 'teacher@tamu.edu')
  raise 'Teacher not found' unless @teacher
  semester = Semester.find_or_create_by!(name: semester_name) { |s| s.active = true }
  @fall_semester = semester if semester_name == 'Fall 2024' # Ensure @fall_semester is set
  spring_semester = Semester.find_or_create_by!(name: 'Spring 2024') { |s| s.active = true }
  @student1 = Student.find_or_create_by!(uin: 123_456_789) do |s|
    s.first_name = 'John'
    s.last_name = 'Doe'
    s.email = 'john.semester@example.com'
    s.teacher = @teacher
    s.semester = semester
    s.semester_id = semester.id
  end
  @student2 = Student.find_or_create_by!(uin: 987_654_321) do |s|
    s.first_name = 'Jane'
    s.last_name = 'Smith'
    s.email = 'jane.semester@example.com'
    s.teacher = @teacher
    s.semester = spring_semester
    s.semester_id = spring_semester.id
  end
  [@student1, @student2].each do |student|
    question = Question.find_or_create_by!(
      category: 'Angular Momentum',
      question: 'Test Question',
      answer_choices: %w[A B C]
    )
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
      ans.template_id = 1
    end
  end
  puts "Students created: #{Student.count}"
  puts "Teacher students: #{@teacher.students.pluck(:email)}"
  puts "Answers created: #{Answer.count}"
end

Given('I am logged in as a teacher') do
  @teacher = Teacher.create!(name: 'Test Teacher', email: 'teacher@tamu.edu')

  # Instead of using allow_any_instance_of which is RSpec specific,
  # set up the session directly for Cucumber
  page.set_rack_session(user_type: 'teacher', user_id: @teacher.id)

  # Visit a page to ensure the session is active
  visit '/'
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

When(/^I click the "(Apply|Drop All Students in .*)" button$/) do |button_text|
  click_button button_text
end

Then('all students in the {string} semester should be deleted') do |semester_name|
  # Check that the students in the specified semester have been deleted
  semester = Semester.find_by(name: semester_name)
  # Ensure the check is scoped to the current teacher's students
  expect(@teacher.students.where(semester: semester).count).to eq(0)
end

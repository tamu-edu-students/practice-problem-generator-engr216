def login_as_teacher
    @teacher = Teacher.find_or_create_by!(email: "test_teacher@tamu.edu", name: "Test Teacher")
    visit "/auth/google_oauth2/callback?state=teacher"
  end
  
  Given('I am on the Teacher Dashboard page') do
    login_as_teacher
    visit teacher_dashboard_path
  end
  
  When('I click the {string} button') do |button_text|
    click_link button_text
  end
  
  Then('I should be brought to the student statistics page') do
    expect(page).to have_current_path(teacher_dashboard_student_statistics_path)
  end
  
  Given('I am on the student statistics page') do
    login_as_teacher
    @student = Student.find_or_create_by!(email: "test_student@tamu.edu") do |student|
      student.first_name = "Test"
      student.last_name = "Student"
      student.uin = "123456789"
      student.teacher_id = @teacher.id
    end
    visit teacher_dashboard_student_statistics_path
  end
  
  When('I click on a student’s name') do
    click_link "#{@student.first_name} #{@student.last_name}"
  end
  
  Then('I should see a summary of the student\'s past problems') do
    @question = Question.create!(category: "Math", question: "2+2?", answers: "4")
    Answer.create!(student_email: @student.email, question_id: @question.id, answer: "4", correctness: true)
    Answer.create!(student_email: @student.email, question_id: @question.id, answer: "3", correctness: false)
    visit teacher_dashboard_student_statistics_show_path(@student, cache_bust: Time.now.to_i)
    expect(page.body).to include("Total problems: 2, Correct: 1, Incorrect: 1")
  end
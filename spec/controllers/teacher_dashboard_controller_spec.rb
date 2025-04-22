require 'rails_helper'
require 'ostruct'
CatSummary = Struct.new(:category, :attempted, :correct, :incorrect)

RSpec.describe TeacherDashboardController, type: :controller do
  let(:teacher) { Teacher.create!(email: 'teacher@example.com', name: 'Teacher 1') }

  let(:fall_semester) do
    Semester.find_or_create_by!(name: 'Fall 2024') { |s| s.active = true }
  end

  let(:spring_semester) do
    Semester.find_or_create_by!(name: 'Spring 2024') { |s| s.active = true }
  end

  # let(:john_student) do
  #   Student.create!(first_name: 'John', last_name: 'Doe', email: 'john@example.com', uin: 123_456_789,
  #                   semester: fall_semester, teacher: teacher)
  # end

  # let(:jane_student) do
  #   Student.create!(first_name: 'Jane', last_name: 'Smith', email: 'jane@example.com', uin: 987_654_321,
  #                   semester: spring_semester, teacher: teacher)
  # end
  let(:john_student) do
    Student.create!(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@example.com',
      uin: 123_456_789,
      teacher: teacher,
      teacher_id: teacher.id,
      semester: fall_semester
    )
  end
  let(:jane_student) do
    Student.create!(
      first_name: 'Jane',
      last_name: 'Smith',
      email: 'jane@example.com',
      uin: 987_654_321,
      teacher: teacher,
      teacher_id: teacher.id,
      semester: spring_semester
    )
  end
  # Define test semesters for delete tests
  let(:test_fall_semester) { Semester.create!(name: "Test Fall #{Time.now.to_i}", active: true) }
  let(:test_spring_semester) { Semester.create!(name: "Test Spring #{Time.now.to_i}", active: true) }
  let(:fall_student) do
    Student.create!(
      first_name: 'Fall',
      last_name: 'Student',
      email: "fall_#{Time.now.to_i}@example.com",
      uin: 123_456_789,
      teacher: teacher,
      semester: test_fall_semester
    )
  end
  let(:spring_student) do
    Student.create!(
      first_name: 'Spring',
      last_name: 'Student',
      email: "spring_#{Time.now.to_i}@example.com",
      uin: 987_654_321,
      teacher: teacher,
      semester: test_spring_semester
    )
  end

  before do
    session[:user_id] = teacher.id
    session[:user_type] = 'teacher'
    john_student
    jane_student
  end

  describe '#require_teacher' do
    it 'redirects if not a teacher' do
      session[:user_type] = 'student'
      get :index
      expect(response).to redirect_to(login_path)
    end

    it 'allows access if teacher' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe '#index' do
    it 'assigns teacher students' do
      get :index
      expect(assigns(:students)).to include(john_student, jane_student)
    end
  end

  describe '#manage_students' do
    it 'loads all semesters and students' do
      get :manage_students
      expect(assigns(:students)).to include(john_student, jane_student)
      expect(assigns(:semesters)).to include(fall_semester, spring_semester)
    end

    it 'filters by semester' do
      get :manage_students, params: { semester_id: fall_semester.id }
      expect(assigns(:students)).to include(john_student)
      expect(assigns(:students)).not_to include(jane_student)
    end
  end

  describe '#student_history_dashboard' do
    before do
      create_answer(john_student, 'Harmonic Motion', 3, true)
      create_answer(jane_student, 'Harmonic Motion', 3, false)
    end

    it 'assigns dropdown students and semesters' do
      get :student_history_dashboard
      expect(assigns(:all_students)).to include(john_student)
      expect(assigns(:semesters)).to include(fall_semester)
    end

    it 'filters by search' do
      get :student_history_dashboard, params: { search: 'john' }
      expect(assigns(:students).pluck(:email)).to include('john@example.com')
    end

    it 'shows student-specific stats with pie data' do
      get :student_history_dashboard,
          params: { student_email: john_student.email, category: 'all', semester_id: fall_semester.id }

      expect(assigns(:student_total_attempted)).to eq(1)
      expect(assigns(:student_correct_pie)).to include(:correct, :incorrect)
      expect(assigns(:student_category_pie_data)['Harmonic Motion']).to include(:correct, :incorrect)
    end

    it 'shows student+category breakdown with pie and table data' do
      get :student_history_dashboard, params: {
        student_email: john_student.email,
        category: 'Harmonic Motion',
        semester_id: fall_semester.id
      }

      expect(assigns(:unique_correct_pie)).to include(:correct, :incorrect)
      expect(assigns(:problem_history).count).to eq(1)
    end

    it 'shows class-wide category performance breakdown' do
      get :student_history_dashboard, params: {
        student_email: 'all',
        category: 'Harmonic Motion',
        semester_id: 'all'
      }

      expect(assigns(:category_question_data)).to be_a(Hash)
      expect(assigns(:category_total_correct)).to be >= 1
    end

    it 'filters students by semester when semester_id is provided' do
      get :student_history_dashboard, params: { semester_id: fall_semester.id }
      expect(assigns(:students)).to include(john_student)
      expect(assigns(:students)).not_to include(jane_student)
    end

    it 'builds category summaries based on filtered students' do
      # isolate only john_student
      Answer.where(student_email: john_student.email).destroy_all
    
      create_answer_for_student(john_student, 'Physics', true)
    
      summaries = controller.send(:build_category_summaries, [john_student])
    
      expect(summaries['Physics'][:attempted]).to eq(1)
      expect(summaries['Physics'][:correct]).to eq(1)
    end
    
  end

  describe '#student_history' do
    it 'renders student history view' do
      get :student_history, params: { student_email: john_student.email }
      expect(response).to render_template('teacher_dashboard/student_history')
    end

    it 'redirects if student is not found' do
      get :student_history, params: { student_email: 'missing@nowhere.com' }
      expect(response).to redirect_to(teacher_dashboard_path)
      expect(flash[:alert]).to eq(I18n.t('teacher.student_not_found'))
    end

    it 'redirects if email param is missing' do
      get :student_history, params: {} # this triggers redirect_with_missing_email_alert
      expect(response).to redirect_to(teacher_dashboard_path)
      expect(flash[:alert]).to eq(I18n.t('teacher.student_email_required'))
    end
  end

  describe '#delete_semester_students' do
    it 'deletes students in a given semester' do
      expect do
        post :delete_semester_students, params: { semester_id: fall_semester.id }
      end.to change(Student, :count).by(-1)
    end

    it 'does not delete students in other semesters' do
      expect do
        post :delete_semester_students, params: { semester_id: fall_semester.id }
      end.not_to(change { Student.where(semester_id: spring_semester.id).count })
    end

    it 'alerts if semester is not found' do
      post :delete_semester_students, params: { semester_id: '9999' }
      expect(flash[:alert]).to include('Semester not found')
    end

    it 'alerts if no semester param given' do
      post :delete_semester_students
      expect(flash[:alert]).to include('No semester selected')
    end
  end

  describe 'private helpers' do
    it '#current_teacher returns current session teacher' do
      expect(controller.send(:current_teacher)).to eq(teacher)
    end

    it '#load_semesters assigns ordered semesters' do
      controller.send(:load_semesters)
      expect(assigns(:semesters)).to include(fall_semester)
    end

    it '#build_category_summaries returns correct hash' do
      create_answer(john_student, 'Physics', 1, true)
      summaries = controller.send(:build_category_summaries, [john_student])
      expect(summaries['Physics'][:correct]).to eq(1)
    end

    it '#format_category_summary returns expected structure' do
      summary = CatSummary.new('Test', 4, 2, 2)

      result = controller.send(:format_category_summary, summary)
      expect(result).to eq(['Test', { attempted: 4, correct: 2, incorrect: 2, percentage: 50.0 }])
    end

    it '#class_performance calculates correctly' do
      create_answer(john_student, 'Physics', 1, true)
      controller.send(:class_performance, [john_student])
      expect(assigns(:total_completed)[:percentage]).to eq(100.0)
    end

    it '#set_student_stats assigns student stats' do
      create_answer(john_student, 'Physics', 1, true)
      controller.instance_variable_set(:@completed_questions, Answer.where(student_email: john_student.email))
      controller.send(:set_student_stats)
      expect(assigns(:percentage_correct)).to eq('100.0%')
    end

    it '#log_student_history_request logs without crashing' do
      expect { controller.send(:log_student_history_request, john_student.email) }.not_to raise_error
    end
  end

  describe 'POST #delete_semester_students' do
    before do
      # Ensure test students exist
      fall_student
      spring_student
    end

    it 'deletes all students in a specific semester' do
      expect do
        post :delete_semester_students, params: { semester_id: test_fall_semester.id }
      end.to change { Student.where(semester: test_fall_semester).count }.by(-1)
    end

    it 'does not delete students in other semesters' do
      expect do
        post :delete_semester_students, params: { semester_id: test_fall_semester.id }
      end.not_to(change { Student.where(semester: test_spring_semester).count })
    end

    it 'redirects with a notice after deletion' do
      post :delete_semester_students, params: { semester_id: test_fall_semester.id }
      expect(response).to redirect_to(manage_students_path)
      expect(flash[:notice]).to include('Deleted')
    end

    it 'redirects with an alert if no semester is provided' do
      post :delete_semester_students
      expect(response).to redirect_to(manage_students_path)
      expect(flash[:alert]).to include('No semester selected')
    end
  end

  private

  def create_answer(student, category, template_id, correct)
    Answer.create!(
      student_email: student.email,
      category: category,
      question_description: "Q for #{category}",
      answer_choices: %w[A B],
      answer: correct ? 'A' : 'B',
      correctness: correct,
      template_id: template_id
    )
  end

  def create_answer_for_student(student, category, correct)
    Answer.create!(
      question_description: "Test question for #{category}",
      answer_choices: %w[A B],
      answer: correct ? 'A' : 'B',
      student_email: student.email,
      correctness: correct,
      category: category
    )
  end
end

# spec/controllers/teacher_dashboard_controller_spec.rb
require 'rails_helper'

RSpec.describe TeacherDashboardController, type: :controller do
  let(:teacher) { Teacher.find_or_create_by!(email: 'test_teacher_1@tamu.edu') { |t| t.name = 'Test_Teacher' } }
  let(:student) do
    Student.find_or_create_by!(uin: '123123123', email: 'student@tamu.edu', teacher: teacher) do |s|
      s.first_name = 'John'
      s.last_name = 'Doe'
    end
  end
  let(:fall_semester) { Semester.find_or_create_by!(name: 'Fall 2024') { |s| s.active = true } }
  let(:spring_semester) { Semester.find_or_create_by!(name: 'Spring 2024') { |s| s.active = true } }

  before do
    session[:user_id] = teacher.id
    session[:user_type] = 'teacher'

    # Create students in different semesters
    @student1 = Student.create!(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@example.com',
      uin: 123_456_789,
      teacher: teacher,
      teacher_id: teacher.id,
      semester: fall_semester
    )

    @student2 = Student.create!(
      first_name: 'Jane',
      last_name: 'Smith',
      email: 'jane@example.com',
      uin: 987_654_321,
      teacher: teacher,
      teacher_id: teacher.id,
      semester: spring_semester
    )
  end

  describe '#require_teacher' do
    it 'redirects to login if not a teacher' do
      session[:user_type] = 'student'
      get :index
      expect(response).to redirect_to(login_path)
    end

    it 'proceeds if teacher is authenticated' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe '#index' do
    it "assigns current teacher's students" do
      get :index
      expect(assigns(:students).to_a).to match_array(teacher.students.to_a)
    end
  end

  describe '#manage_students' do
    it 'assigns all students when no semester filter is provided' do
      get :manage_students
      expect(assigns(:students)).to include(@student1, @student2)
    end

    it 'filters students by semester when semester_id is provided' do
      get :manage_students, params: { semester_id: fall_semester.id }
      expect(assigns(:students)).to include(@student1)
      expect(assigns(:students)).not_to include(@student2)
    end

    it 'loads all semesters for the dropdown' do
      get :manage_students
      expect(assigns(:semesters)).to include(fall_semester, spring_semester)
    end
  end

  describe '#student_history_dashboard' do
    it 'assigns all students without search' do
      get :student_history_dashboard
      expect(assigns(:all_students)).to eq(teacher.students)
    end

    it 'filters students with search' do
      Student.find_or_create_by!(uin: '124124124', email: 'john@tamu.edu', teacher: teacher, first_name: 'John',
                                 last_name: 'Doe')
      get :student_history_dashboard, params: { search: 'john' }
      expect(assigns(:students).pluck(:first_name)).to include('John')
    end

    it 'filters students by semester when semester_id is provided' do
      get :student_history_dashboard, params: { semester_id: fall_semester.id }
      expect(assigns(:students)).to include(@student1)
      expect(assigns(:students)).not_to include(@student2)
    end

    it 'builds category summaries based on filtered students' do
      # Create some answers for students
      Answer.create!(
        question_description: 'Test question',
        answer_choices: %w[A B],
        answer: 'A',
        student_email: @student1.email,
        correctness: true,
        category: 'Physics'
      )

      Answer.create!(
        question_description: 'Test question 2',
        answer_choices: %w[A B],
        answer: 'B',
        student_email: @student2.email,
        correctness: false,
        category: 'Physics'
      )

      get :student_history_dashboard, params: { semester_id: fall_semester.id }

      # Verify that only answers for student1 are included in summaries
      expect(assigns(:category_summaries)['Physics'][:attempted]).to eq(1)
      expect(assigns(:category_summaries)['Physics'][:correct]).to eq(1)
    end
  end

  describe '#student_history' do
    it 'shows student history when valid student is provided' do
      student = Student.create!(
        first_name: 'Test',
        last_name: 'Student',
        email: "test_#{Time.now.to_i}@example.com",
        uin: 123_456_789,
        teacher: teacher
      )
      get :student_history, params: { student_email: student.email }
      expect(response).to render_template 'teacher_dashboard/student_history'
    end

    it 'redirects to dashboard when student not found' do
      get :student_history, params: { student_email: 'nonexistent@example.com' }
      expect(response).to redirect_to(teacher_dashboard_path)
      expect(flash[:alert]).to eq(I18n.t('teacher.student_not_found'))
    end
  end

  describe '#current_teacher' do
    it 'returns current teacher' do
      expect(controller.send(:current_teacher)).to eq(teacher)
    end

    it 'returns nil if no teacher' do
      session[:user_id] = nil
      expect(controller.send(:current_teacher)).to be_nil
    end
  end

  describe '#build_category_summaries' do
    it 'builds category summaries' do
      create_answer(student)
      result = controller.send(:build_category_summaries, [student])
      expect(result['Math'][:correct]).to eq(1)
    end
  end

  describe '#format_category_summary' do
    it 'formats summary with percentage' do
      # Use a Struct to mimic the grouped Answer result
      cat = instance_double(Struct.new(:category, :attempted, :correct, :incorrect),
                            category: 'Math', attempted: 2, correct: 1, incorrect: 1)
      result = controller.send(:format_category_summary, cat)
      expect(result).to eq(['Math', { attempted: 2, correct: 1, incorrect: 1, percentage: 50.0 }])
    end

    it 'returns 0% when no attempts' do
      cat = instance_double(Struct.new(:category, :attempted, :correct, :incorrect),
                            category: 'Math', attempted: 0, correct: 0, incorrect: 0)
      result = controller.send(:format_category_summary, cat)
      expect(result[1][:percentage]).to eq(0)
    end
  end

  describe '#class_performance' do
    it 'calculates class performance' do
      create_answer(student)
      controller.send(:class_performance, [student])
      expect(assigns(:total_completed)[:percentage]).to eq(100.0)
    end
  end

  describe '#set_student_stats' do
    it 'sets stats with answers' do
      create_answer(student)
      controller.instance_variable_set(:@completed_questions, Answer.where(student_email: student.email))
      controller.send(:set_student_stats)
      expect(assigns(:percentage_correct)).to eq('100.0%')
    end

    it 'sets N/A when no answers' do
      controller.instance_variable_set(:@completed_questions, Answer.none)
      controller.send(:set_student_stats)
      expect(assigns(:percentage_correct)).to eq('N/A')
    end
  end

  describe 'POST #delete_semester_students' do
    before do
      @test_fall_semester = Semester.create!(name: "Test Fall #{Time.now.to_i}", active: true)
      @test_spring_semester = Semester.create!(name: "Test Spring #{Time.now.to_i}", active: true)

      @fall_student = Student.create!(
        first_name: 'Fall',
        last_name: 'Student',
        email: "fall_#{Time.now.to_i}@example.com",
        uin: 123_456_789,
        teacher: teacher,
        semester: @test_fall_semester
      )

      @spring_student = Student.create!(
        first_name: 'Spring',
        last_name: 'Student',
        email: "spring_#{Time.now.to_i}@example.com",
        uin: 987_654_321,
        teacher: teacher,
        semester: @test_spring_semester
      )
    end

    it 'deletes all students in a specific semester' do
      expect do
        post :delete_semester_students, params: { semester_id: @test_fall_semester.id }
      end.to change { Student.where(semester: @test_fall_semester).count }.by(-1)
    end

    it 'does not delete students in other semesters' do
      expect do
        post :delete_semester_students, params: { semester_id: @test_fall_semester.id }
      end.not_to(change { Student.where(semester: @test_spring_semester).count })
    end

    it 'redirects with a notice after deletion' do
      post :delete_semester_students, params: { semester_id: @test_fall_semester.id }
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

  def create_answer(student)
    Answer.find_or_create_by!(
      student_email: student.email,
      category: 'Math',
      correctness: true,
      question_id: Question.find_or_create_by!(category: 'Math', question: 'What is 2 + 2?').id,
      question_description: 'What is 2 + 2?',
      answer_choices: ['4'],
      answer: '4'
    )
  end
end

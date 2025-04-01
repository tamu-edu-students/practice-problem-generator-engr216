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

  before do
    session[:user_id] = teacher.id
    session[:user_type] = 'teacher'
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
    it 'assigns current teacher’s students' do
      get :index
      expect(assigns(:students)).to eq(teacher.students)
    end
  end

  describe '#manage_students' do
    it 'assigns all students' do
      get :manage_students
      expect(assigns(:students)).to eq(Student.all)
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
  end

  describe '#student_history' do
    it 'assigns student' do
      get :student_history, params: { uin: student.uin }
      expect(assigns(:student)).to eq(student)
    end

    it 'redirects to teacher dashboard with message for invalid student' do
      get :student_history, params: { uin: '999999998' }
      expect(response).to redirect_to(teacher_dashboard_path)
      expect(flash[:alert]).to eq('Student not found.')
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

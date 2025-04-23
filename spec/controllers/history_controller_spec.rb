require 'rails_helper'

RSpec.describe HistoryController, type: :controller do
  describe 'GET #show' do
    context 'when student is not logged in' do
      it 'redirects to login_path' do
        get :show
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when student is logged in' do
      let!(:student) do
        Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
      end
      let(:correct_answers) { %w[A B] }

      before do
        question = {
          type: 'rigid_body_statics',
          question: 'Dummy multi-part question',
          answer: correct_answers,
          input_fields: [
            { label: 'Answer 1', key: 'rbs_answer_1', type: 'text' },
            { label: 'Answer 2', key: 'rbs_answer_2', type: 'text' }
          ]
        }
        controller.instance_variable_set(:@question, question)
        session[:current_question] = question.to_json
        session[:user_id] = student.id
        get :show
      end

      it 'assigns @student' do
        expect(assigns(:student)).to eq(student)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'when student has completed questions' do
      let(:student) do
        Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
      end

      before do
        session[:user_id] = student.id
        Answer.create!(student_email: student.email, correctness: true, question_description: 'Q1',
                       answer_choices: %w[A B], answer: 'A')
        Answer.create!(student_email: student.email, correctness: false, question_description: 'Q2',
                       answer_choices: %w[C D], answer: 'C')
        get :show
      end

      it 'assigns correct statistics' do
        expect(assigns(:attempted)).to eq(2)
        expect(assigns(:correct)).to eq(1)
        expect(assigns(:incorrect)).to eq(1)
        expect(assigns(:percentage_correct)).to eq(50.0)
      end
    end
  end

  describe 'GET #teacher_view' do
    let(:teacher) { Teacher.create!(email: 'teacher@tamu.edu', name: 'Test Teacher') }
    let(:student) do
      Student.create!(email: 'student@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    context 'when teacher is not logged in' do
      it 'redirects to login_path' do
        get :teacher_view
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when teacher is logged in' do
      before { session[:user_id] = teacher.id }

      it 'redirects to teacher_dashboard_path with invalid student_email' do
        get :teacher_view, params: { student_email: 'nonexistent@example.com' }
        expect(response).to redirect_to(teacher_dashboard_path)
      end

      it 'assigns @student and statistics with valid student_email' do
        Answer.create!(student_email: student.email, correctness: true, question_description: 'Q1',
                       answer_choices: %w[A B], answer: 'A')
        get :teacher_view, params: { student_email: student.email }
        expect(assigns(:student)).to eq(student)
        expect(assigns(:attempted)).to eq(1)
        expect(assigns(:correct)).to eq(1)
      end

      it 'renders show template with valid student_email' do
        Answer.create!(student_email: student.email, correctness: true, question_description: 'Q1',
                       answer_choices: %w[A B], answer: 'A')
        get :teacher_view, params: { student_email: student.email }
        expect(response).to render_template(:show)
      end
    end
  end
end

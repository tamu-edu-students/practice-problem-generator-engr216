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
  end
end

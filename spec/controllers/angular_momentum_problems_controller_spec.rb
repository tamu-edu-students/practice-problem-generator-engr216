# spec/controllers/angular_momentum_problems_controller_spec.rb
require 'rails_helper'

RSpec.describe AngularMomentumProblemsController, type: :controller do
  describe 'GET #generate' do
    let(:dummy_question) do
      {
        type: 'angular_momentum',
        question: 'Dummy angular momentum question',
        answer: '12.0',
        input_fields: [{ label: 'Angular Momentum', key: 'am_answer', type: 'text' }]
      }
    end
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    let(:generator) do
      instance_double(AngularMomentumProblemGenerator, generate_questions: [dummy_question])
    end

    before do
      allow(AngularMomentumProblemGenerator).to receive(:new)
        .with('Angular Momentum')
        .and_return(generator)
      get :generate
      session[:user_id] = student.id
    end

    it 'assigns @category as "Angular Momentum"', :aggregate_failures do
      expect(assigns(:category)).to eq('Angular Momentum')
    end

    it 'assigns @question from the generator', :aggregate_failures do
      expect(assigns(:question)).to eq(dummy_question)
    end

    it 'stores the question in session as JSON', :aggregate_failures do
      expect(session[:current_question]).to eq(dummy_question.to_json)
    end

    it 'renders the angular momentum problem view', :aggregate_failures do
      expect(response).to render_template('practice_problems/angular_momentum_problem')
    end
  end

  describe 'POST #check_answer' do
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    before do
      session[:user_id] = student.id
    end

    context 'when the answer is a single numeric value' do
      let(:question) do
        {
          type: 'angular_momentum',
          question: 'Dummy angular momentum question',
          answer: '12.0',
          input_fields: [{ label: 'Angular Momentum', key: 'am_answer', type: 'text' }]
        }
      end

      before do
        session[:current_question] = question.to_json
      end

      it 'returns correct feedback for an exact match', :aggregate_failures do
        post :check_answer, params: { am_answer: '12.0' }
        expect(assigns(:feedback_message)).to eq('Correct, the answer 12.0 is right!')
      end

      it 'returns correct feedback within tolerance', :aggregate_failures do
        post :check_answer, params: { am_answer: '12.02' }
        expect(assigns(:feedback_message)).to eq('Correct, the answer 12.0 is right!')
      end

      it 'returns incorrect feedback out of tolerance', :aggregate_failures do
        post :check_answer, params: { am_answer: '13.0' }
        expect(assigns(:feedback_message)).to eq('Incorrect, the correct answer is 12.0.')
      end
    end

    context 'when the answer is a single string' do
      let(:question) do
        {
          type: 'angular_momentum',
          question: 'Dummy string question',
          answer: 'omega',
          input_fields: [{ label: 'Angular Quantity', key: 'am_answer', type: 'text' }]
        }
      end

      before { session[:current_question] = question.to_json }

      it 'returns correct feedback for a matching string', :aggregate_failures do
        post :check_answer, params: { am_answer: 'omega' }
        expect(assigns(:feedback_message)).to eq('Correct, the answer omega is right!')
      end

      it 'returns incorrect feedback for a non-matching string', :aggregate_failures do
        post :check_answer, params: { am_answer: 'theta' }
        expect(assigns(:feedback_message)).to eq('Incorrect, the correct answer is omega.')
      end
    end

    context 'when the answer is multi-part' do
      let(:question) do
        {
          type: 'angular_momentum',
          question: 'Multi-part angular momentum question',
          answer: ['3.14', '2.00'],
          input_fields: [
            { label: 'Part 1', key: 'am_answer_1', type: 'text' },
            { label: 'Part 2', key: 'am_answer_2', type: 'text' }
          ]
        }
      end

      before do
        session[:current_question] = question.to_json
      end

      it 'returns correct feedback when all parts match within tolerance', :aggregate_failures do
        # rubocop:disable Naming/VariableNumber
        post :check_answer, params: { am_answer_1: '3.13', am_answer_2: '2.01' }
        # rubocop:enable Naming/VariableNumber
        expect(assigns(:feedback_message)).to eq('Correct, the answer 3.14, 2.00 is right!')
      end

      it 'returns incorrect feedback when one part is incorrect', :aggregate_failures do
        # rubocop:disable Naming/VariableNumber
        post :check_answer, params: { am_answer_1: '3.14', am_answer_2: '1.90' }
        # rubocop:enable Naming/VariableNumber
        expect(assigns(:feedback_message)).to eq('Incorrect, the correct answer is 3.14, 2.00.')
      end

      it 'returns incorrect feedback if a part is a non-numeric mismatch', :aggregate_failures do
        # rubocop:disable Naming/VariableNumber
        post :check_answer, params: { am_answer_1: 'hello', am_answer_2: '2.00' }
        # rubocop:enable Naming/VariableNumber
        expect(assigns(:feedback_message)).to eq('Incorrect, the correct answer is 3.14, 2.00.')
      end
    end
  end
end

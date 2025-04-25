# spec/controllers/particle_statics_problems_controller_spec.rb
require 'rails_helper'

RSpec.describe ParticleStaticsProblemsController, type: :controller do
  describe 'GET #generate' do
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    let(:dummy_question) do
      {
        type: 'particle_statics',
        question: 'Dummy particle statics question',
        answer: '12.0',
        input_fields: [{ label: 'Force', key: 'ps_answer', type: 'text' }]
      }
    end

    let(:generator) do
      instance_double(ParticleStaticsProblemGenerator, generate_questions: [dummy_question])
    end

    before do
      allow(ParticleStaticsProblemGenerator).to receive(:new)
        .with('Particle Statics')
        .and_return(generator)
      get :generate
      session[:user_id] = student.id
    end

    it 'assigns @category as "Particle Statics"', :aggregate_failures do
      expect(assigns(:category)).to eq('Particle Statics')
    end

    it 'assigns @question from the generator', :aggregate_failures do
      expect(assigns(:question)).to eq(dummy_question)
    end

    it 'stores the question in session as JSON', :aggregate_failures do
      expect(session[:current_question]).to eq(dummy_question.to_json)
    end

    it 'renders the particle statics problem view', :aggregate_failures do
      expect(response).to render_template('practice_problems/particle_statics_problem')
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
          type: 'particle_statics',
          question: 'Dummy particle statics question',
          answer: '12.0',
          input_fields: [{ label: 'Force', key: 'ps_answer', type: 'text' }]
        }
      end

      before do
        session[:current_question] = question.to_json
      end

      it 'returns correct feedback for an exact match', :aggregate_failures do
        post :check_answer, params: { ps_answer: '12.0' }
        expect(assigns(:feedback_message)).to eq('Correct, the answer 12.0 is right!')
      end

      it 'returns correct feedback within tolerance', :aggregate_failures do
        post :check_answer, params: { ps_answer: '12.02' }
        expect(assigns(:feedback_message)).to eq('Correct, the answer 12.0 is right!')
      end

      it 'returns incorrect feedback out of tolerance', :aggregate_failures do
        post :check_answer, params: { ps_answer: '13.0' }
        expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
      end
    end

    context 'when the answer is a single string' do
      let(:question) do
        {
          type: 'particle_statics',
          question: 'Dummy string question',
          answer: 'tension',
          input_fields: [{ label: 'Force', key: 'ps_answer', type: 'text' }]
        }
      end

      before { session[:current_question] = question.to_json }

      it 'returns correct feedback for a matching string', :aggregate_failures do
        post :check_answer, params: { ps_answer: 'tension' }
        expect(assigns(:feedback_message)).to eq('Correct, the answer tension is right!')
      end

      it 'returns incorrect feedback for a non-matching string', :aggregate_failures do
        post :check_answer, params: { ps_answer: 'force' }
        expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
      end
    end

    context 'when the answer is multi-part' do
      let(:question) do
        {
          type: 'particle_statics',
          question: 'Multi-part particle statics question',
          answer: ['3.14', '2.00'],
          input_fields: [
            { label: 'Part 1', key: 'ps_answer_1', type: 'text' },
            { label: 'Part 2', key: 'ps_answer_2', type: 'text' }
          ]
        }
      end

      before do
        session[:current_question] = question.to_json
      end

      it 'returns correct feedback when all parts match within tolerance', :aggregate_failures do
        # rubocop:disable Naming/VariableNumber
        post :check_answer, params: { ps_answer_1: '3.13', ps_answer_2: '2.01' }
        # rubocop:enable Naming/VariableNumber
        expect(assigns(:feedback_message)).to eq('Correct, the answer 3.14, 2.00 is right!')
      end

      it 'returns incorrect feedback when one part is incorrect', :aggregate_failures do
        # rubocop:disable Naming/VariableNumber
        post :check_answer, params: { ps_answer_1: '3.14', ps_answer_2: '1.90' }
        # rubocop:enable Naming/VariableNumber
        expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
      end

      it 'returns incorrect feedback if a part is a non-numeric mismatch', :aggregate_failures do
        # rubocop:disable Naming/VariableNumber
        post :check_answer, params: { ps_answer_1: 'hello', ps_answer_2: '2.00' }
        # rubocop:enable Naming/VariableNumber
        expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
      end
    end
  end
end

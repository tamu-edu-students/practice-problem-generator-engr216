# rubocop:disable Naming/VariableNumber
require 'rails_helper'

RSpec.describe HarmonicMotionProblemsController, type: :controller do
  describe 'GET #generate' do
    let(:dummy_question) do
      {
        type: 'simple_harmonic_motion',
        question: 'Dummy question',
        answer: '1',
        input_fields: [{ label: 'Period T', key: 'shm_answer', type: 'text' }]
      }
    end

    let(:generator) do
      instance_double(HarmonicMotionProblemGenerator, generate_questions: [dummy_question])
    end

    before do
      allow(HarmonicMotionProblemGenerator).to receive(:new)
        .with('Harmonic Motion')
        .and_return(generator)
      get :generate
    end

    it 'assigns @category as "Harmonic Motion"', :aggregate_failures do
      expect(assigns(:category)).to eq('Harmonic Motion')
    end

    it 'assigns @question from the generator', :aggregate_failures do
      expect(assigns(:question)).to eq(dummy_question)
    end

    it 'stores the question in session as JSON', :aggregate_failures do
      expect(session[:current_question]).to eq(dummy_question.to_json)
    end

    it 'renders the harmonic motion problem view', :aggregate_failures do
      expect(response).to render_template('practice_problems/harmonic_motion_problem')
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
          type: 'simple_harmonic_motion',
          question: 'Dummy single numeric question',
          answer: '1',
          input_fields: [{ label: 'Period T', key: 'shm_answer', type: 'text' }]
        }
      end

      before do
        session[:current_question] = question.to_json
      end

      it 'returns correct feedback for an exact match', :aggregate_failures do
        post :check_answer, params: { shm_answer: '1' }
        expect(assigns(:feedback_message)).to eq('Correct, the answer 1 is right!')
      end

      it 'returns correct feedback for a near match within tolerance', :aggregate_failures do
        post :check_answer, params: { shm_answer: '1.03' }
        expect(assigns(:feedback_message)).to eq('Correct, the answer 1 is right!')
      end

      it 'returns incorrect feedback for an answer out of tolerance', :aggregate_failures do
        post :check_answer, params: { shm_answer: '1.1' }
        expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
      end
    end

    context 'when the answer is a single non‑numeric string' do
      let(:question) do
        {
          type: 'simple_harmonic_motion',
          question: 'Dummy string question',
          answer: 'one',
          input_fields: [{ label: 'Answer', key: 'shm_answer', type: 'text' }]
        }
      end

      before { session[:current_question] = question.to_json }

      it 'returns correct feedback when the submitted answer exactly matches', :aggregate_failures do
        post :check_answer, params: { shm_answer: 'one' }
        expect(assigns(:feedback_message)).to eq('Correct, the answer one is right!')
      end

      it 'returns incorrect feedback when the submitted answer does not match', :aggregate_failures do
        post :check_answer, params: { shm_answer: 'two' }
        expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
      end
    end

    context 'when multi-part answer evaluation raises an exception' do
      let(:question) do
        {
          type: 'simple_harmonic_motion',
          question: 'Dummy multi-part question',
          answer: ['3.14', '1.00'],
          input_fields: [
            { label: 'Answer part 1', key: 'shm_answer_1', type: 'text' },
            { label: 'Answer part 2', key: 'shm_answer_2', type: 'text' }
          ]
        }
      end

      before do
        session[:current_question] = question.to_json
        allow(controller).to receive(:numeric?).and_raise(ArgumentError)
      end

      it 'rescues the error and returns incorrect feedback', :aggregate_failures do
        post :check_answer, params: { shm_answer_1: 'x', shm_answer_2: 'y' }
        expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
      end
    end

    context 'when the answer is multi-part numeric' do
      let(:question) do
        {
          type: 'simple_harmonic_motion',
          question: 'Dummy multi-part question',
          answer: ['3.14', '1.00'],
          input_fields: [
            { label: 'Answer part 1', key: 'shm_answer_1', type: 'text' },
            { label: 'Answer part 2', key: 'shm_answer_2', type: 'text' }
          ]
        }
      end

      before do
        session[:current_question] = question.to_json
      end

      it 'returns correct feedback when all parts match exactly', :aggregate_failures do
        post :check_answer, params: { shm_answer_1: '3.14', shm_answer_2: '1.00' }
        expect(assigns(:feedback_message))
          .to eq('Correct, the answer 3.14, 1.00 is right!')
      end

      it 'returns correct feedback when answers are within tolerance', :aggregate_failures do
        post :check_answer, params: { shm_answer_1: '3.15', shm_answer_2: '1.03' }
        expect(assigns(:feedback_message))
          .to eq('Correct, the answer 3.14, 1.00 is right!')
      end

      it 'returns incorrect feedback if one part is out of tolerance', :aggregate_failures do
        post :check_answer, params: { shm_answer_1: '3.14', shm_answer_2: '1.1' }
        expect(assigns(:feedback_message))
          .to eq('Incorrect, try again or press View Answer.')
      end

      it 'returns incorrect feedback if a submitted part is non-numeric', :aggregate_failures do
        post :check_answer, params: { shm_answer_1: 'abc', shm_answer_2: '1.00' }
        expect(assigns(:feedback_message))
          .to eq('Incorrect, try again or press View Answer.')
      end
    end
  end
end
# rubocop:enable Naming/VariableNumber

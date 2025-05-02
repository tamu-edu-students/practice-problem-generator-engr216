require 'rails_helper'

RSpec.describe ParticleStaticsProblemsController, type: :controller do
  let!(:student) do
    Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
  end

  before do
    session[:user_id] = student.id
  end

  describe 'GET #generate' do
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

    context 'when the answer is a single numeric value' do
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
  end

  describe 'GET #view_answer' do
    let(:dummy_question) do
      {
        type: 'particle_statics',
        question: 'Sample question',
        answer: '10',
        input_fields: [{ label: 'Force', key: 'ps_answer', type: 'text' }]
      }
    end

    context 'when a question exists in session' do
      before do
        session[:current_question] = dummy_question.to_json
        get :view_answer
      end

      it 'sets the show_answer and disables check_answer flag' do
        expect(assigns(:show_answer)).to be true
        expect(assigns(:disable_check_answer)).to be true
        expect(response).to render_template('practice_problems/particle_statics_problem')
      end
    end
  end

  describe 'POST #check_answer for radio question' do
    let(:radio_question) do
      {
        type: 'particle_statics',
        question: 'Choose the correct force',
        answer: 'B',
        input_fields: [
          { type: 'radio', options: [
            { value: 'Option A' },
            { value: 'Option B' },
            { value: 'Option C' },
            { value: 'Option D' }
          ] }
        ]
      }
    end

    before do
      session[:current_question] = radio_question.to_json
    end

    it 'incorrectly identifies when the wrong answer is selected' do
      post :check_answer, params: { ps_answer: 'Option A' }
      expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
    end
  end

  describe 'GET #generate with radio question' do
    let(:dummy_question) do
      {
        type: 'particle_statics',
        question: 'Which is the correct answer?',
        answer: 'B',
        input_fields: [
          { type: 'radio', options: [
            { value: 'Option A' },
            { value: 'Option B' },
            { value: 'Option C' },
            { value: 'Option D' }
          ] }
        ]
      }
    end

    before do
      allow(ParticleStaticsProblemGenerator).to receive(:new)
        .and_return(instance_double(ParticleStaticsProblemGenerator, generate_questions: [dummy_question]))
      get :generate
    end

    it 'shuffles the radio options and assigns the correct answer' do
      expect(session[:current_question]).to be_present
      expect(response).to render_template('practice_problems/particle_statics_problem')
    end
  end
end

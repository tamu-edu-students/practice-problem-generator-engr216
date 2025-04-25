# spec/controllers/harmonic_motion_problems_controller_spec.rb
require 'rails_helper'

RSpec.describe HarmonicMotionProblemsController, type: :controller do
  let(:dummy_question) do
    {
      type: 'simple_harmonic_motion',
      question: 'Dummy question',
      answer: '1',
      input_fields: [{ label: 'Period T', key: 'shm_answer', type: 'text' }]
    }
  end

  let!(:student) do
    Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
  end

  before do
    session[:user_id] = student.id
  end

  describe 'GET #generate' do
    let(:generator) do
      instance_double(HarmonicMotionProblemGenerator, generate_questions: [dummy_question])
    end

    before do
      allow(HarmonicMotionProblemGenerator).to receive(:new)
        .with('Harmonic Motion')
        .and_return(generator)
      get :generate
    end

    it 'assigns @category and renders view' do
      expect(assigns(:category)).to eq('Harmonic Motion')
      expect(assigns(:question)).to eq(dummy_question)
      expect(response).to render_template('practice_problems/harmonic_motion_problem')
    end
  end

  describe 'POST #check_answer' do
    before { session[:current_question] = dummy_question.to_json }

    it 'gives correct feedback for correct answer' do
      post :check_answer, params: { shm_answer: '1' }
      expect(assigns(:feedback_message)).to eq('Correct, the answer 1 is right!')
    end

    it 'gives incorrect feedback for wrong answer' do
      post :check_answer, params: { shm_answer: '2' }
      expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
    end
  end

  describe 'GET #view_answer' do
    context 'when session has a question' do
      before do
        session[:current_question] = dummy_question.to_json
        get :view_answer
      end

      it 'sets flags and renders view' do
        expect(assigns(:show_answer)).to be true
        expect(assigns(:disable_check_answer)).to be true
        expect(response).to render_template('practice_problems/harmonic_motion_problem')
      end
    end

    context 'when session has no question' do
      before { get :view_answer }

      it 'redirects to generate path' do
        expect(response).to redirect_to(generate_harmonic_motion_problems_path)
      end
    end
  end

  describe 'POST #check_answer for multi-part answers' do
    let(:multi_part_question) do
      {
        type: 'simple_harmonic_motion',
        question: 'Multi-part SHM question',
        answer: ['2.00', '3.00'],
        input_fields: [
          { label: 'Part 1', key: 'shm_answer_1', type: 'text' },
          { label: 'Part 2', key: 'shm_answer_2', type: 'text' }
        ]
      }
    end

    before do
      session[:current_question] = multi_part_question.to_json
    end

    it 'returns correct feedback when both parts are correct within tolerance' do
      post :check_answer, params: { 'shm_answer_1' => '2.01', 'shm_answer_2' => '2.99' }
      expect(assigns(:feedback_message)).to eq('Correct, the answer 2.00, 3.00 is right!')
    end

    it 'returns incorrect feedback when one part is incorrect' do
      post :check_answer, params: { 'shm_answer_1' => '2.00', 'shm_answer_2' => '4.00' }
      expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
    end

    it 'returns incorrect feedback when a non-numeric value is submitted' do
      post :check_answer, params: { 'shm_answer_1' => 'abc', 'shm_answer_2' => '3.00' }
      expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
    end
  end

  describe 'POST #check_answer with radio buttons' do
    let(:radio_question) do
      {
        type: 'simple_harmonic_motion',
        question: 'Select the correct option',
        answer: 'CorrectValue',
        input_fields: [
          { type: 'radio', options: [{ value: 'CorrectValue' }, { value: 'WrongValue' }] }
        ]
      }
    end

    before { session[:current_question] = radio_question.to_json }

    it 'gives correct feedback when correct radio option is selected' do
      post :check_answer, params: { shm_answer: 'CorrectValue' }
      expect(assigns(:feedback_message)).to match(/Correct, the answer [A-D] is right!/)
    end

    it 'gives incorrect feedback when wrong radio option is selected' do
      post :check_answer, params: { shm_answer: 'WrongValue' }
      expect(assigns(:feedback_message)).to match(/Incorrect, the correct answer is [A-D]\./)
    end
  end

  describe 'POST #check_answer when numeric? raises error' do
    let(:faulty_question) do
      {
        type: 'simple_harmonic_motion',
        question: 'Faulty numeric check',
        answer: ['1.00', '2.00'],
        input_fields: [
          { label: 'Part 1', key: 'shm_answer_1', type: 'text' },
          { label: 'Part 2', key: 'shm_answer_2', type: 'text' }
        ]
      }
    end

    before do
      session[:current_question] = faulty_question.to_json
      allow(controller).to receive(:numeric?).and_raise(ArgumentError)
    end

    it 'handles numeric? exception gracefully' do
      post :check_answer, params: { 'shm_answer_1' => 'x', 'shm_answer_2' => 'y' }
      expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
    end
  end
end

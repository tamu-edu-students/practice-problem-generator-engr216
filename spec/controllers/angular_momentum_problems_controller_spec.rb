require 'rails_helper'

RSpec.describe AngularMomentumProblemsController, type: :controller do
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

  before do
    session[:user_id] = student.id
  end

  describe 'GET #generate' do
    let(:generator) do
      instance_double(AngularMomentumProblemGenerator, generate_questions: [dummy_question])
    end

    before do
      allow(AngularMomentumProblemGenerator).to receive(:new)
        .with('Angular Momentum')
        .and_return(generator)
      get :generate
    end

    it 'assigns @category as "Angular Momentum"' do
      expect(assigns(:category)).to eq('Angular Momentum')
    end

    it 'assigns @question from the generator' do
      expect(assigns(:question)).to eq(dummy_question)
    end

    it 'stores the question in session as JSON' do
      expect(session[:current_question]).to eq(dummy_question.to_json)
    end

    it 'renders the angular momentum problem view' do
      expect(response).to render_template('practice_problems/angular_momentum_problem')
    end
  end

  describe 'POST #check_answer' do
    before do
      session[:current_question] = dummy_question.to_json
    end

    it 'returns correct feedback for a correct numeric answer' do
      post :check_answer, params: { am_answer: '12.0' }
      expect(assigns(:feedback_message)).to eq('Correct, the answer 12.0 is right!')
    end

    it 'returns incorrect feedback for a wrong answer' do
      post :check_answer, params: { am_answer: '15.0' }
      expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
    end
  end

  describe 'GET #view_answer' do
    context 'when a question exists in session' do
      before do
        session[:current_question] = dummy_question.to_json
        get :view_answer
      end

      it 'shows the answer and disables check', :aggregate_failures do
        expect(assigns(:show_answer)).to be true
        expect(assigns(:disable_check_answer)).to be true
        expect(response).to render_template('practice_problems/angular_momentum_problem')
      end
    end

    context 'when no question exists in session' do
      before { get :view_answer }

      it 'redirects to generate path' do
        expect(response).to redirect_to(generate_angular_momentum_problems_path)
      end
    end
  end

  describe 'POST #check_answer with radio button question' do
    let(:radio_question) do
      {
        type: 'angular_momentum',
        question: 'Pick the correct option',
        answer: 'B',
        input_fields: [
          { type: 'radio',
            options: [{ value: 'Option 1' }, { value: 'Option 2' }, { value: 'Option 3' }, { value: 'Option 4' }] }
        ]
      }
    end

    before do
      session[:current_question] = radio_question.to_json
    end

    it 'returns incorrect feedback when wrong radio option selected' do
      post :check_answer, params: { am_answer: 'Option 3' }
      expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
    end
  end

  describe 'Helper methods coverage' do
    controller = described_class.new

    it 'handles numeric? correctly' do
      expect(controller.send(:numeric?, '3.14')).to be true
      expect(controller.send(:numeric?, 'abc')).to be false
    end

    it 'extract_answer_choices returns empty array when no choices' do
      controller.instance_variable_set(:@question, {})
      expect(controller.send(:extract_answer_choices)).to eq('[]')
    end

    it 'extract_answer_choices handles JSON conversion' do
      controller.instance_variable_set(:@question, { answer_choices: [{ a: 1 }] })
      expect(controller.send(:extract_answer_choices)).to eq('[{"a":1}]')
    end
  end

  describe 'POST #check_answer for multi-part answers' do
    let(:multi_part_question) do
      {
        type: 'angular_momentum',
        question: 'Calculate both values',
        answer: ['5.00', '10.00'],
        input_fields: [
          { label: 'Part 1', key: 'am_answer_1', type: 'text' },
          { label: 'Part 2', key: 'am_answer_2', type: 'text' }
        ]
      }
    end

    before do
      session[:current_question] = multi_part_question.to_json
    end

    it 'returns correct feedback when both parts are correct within tolerance' do
      post :check_answer, params: { 'am_answer_1' => '5.01', 'am_answer_2' => '10.00' }
      expect(assigns(:feedback_message)).to eq('Correct, the answer 5.00, 10.00 is right!')
    end

    it 'returns incorrect feedback when one part is wrong' do
      post :check_answer, params: { 'am_answer_1' => '5.00', 'am_answer_2' => '11.00' }
      expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
    end

    it 'returns incorrect feedback when a non-numeric value is submitted' do
      post :check_answer, params: { 'am_answer_1' => 'abc', 'am_answer_2' => '10.00' }
      expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
    end
  end
end

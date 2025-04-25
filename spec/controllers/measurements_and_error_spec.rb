# rubocop:disable RSpec/MultipleDescribes

require 'rails_helper'

RSpec.describe MeasurementsAndErrorProblemGenerator, type: :model do
  subject(:generator) { described_class.new('Measurements and Error') }

  describe '#initialize' do
    it 'sets the category correctly' do
      expect(generator.instance_variable_get(:@category)).to eq('Measurements and Error')
    end
  end

  describe '#generate_questions' do
    let(:questions) { generator.generate_questions }

    it 'returns an array containing at least one question with correct type' do
      expect(questions).to be_an(Array)
      expect(questions.size).to be >= 1
      expect(questions.first[:type]).to eq('measurements_error')
    end
  end

  describe 'question structure' do
    let(:question) { generator.generate_questions.first }

    it 'has question, answer, and input_fields keys' do
      expect(question).to include(:question, :answer, :input_fields)
      expect(question[:input_fields]).to be_an(Array)
    end

    context 'when multiple choice' do
      let(:mc_question) do
        question.merge(input_fields: [{ options: [{ value: 'A' }, { value: 'B' }] }], answer: 'A')
      end

      it 'includes the answer among the options' do
        opts = mc_question[:input_fields].first[:options].map { |opt| opt[:value] }
        expect(opts).to include(mc_question[:answer])
      end
    end

    context 'when fill_in' do
      let(:fill_question) do
        {
          question: 'Fill blank',
          answer: '42',
          type: 'measurements_error',
          input_fields: [{ key: 'measurement_answer', type: 'text' }]
        }
      end

      it 'provides a non-empty answer string' do
        expect(fill_question[:answer]).to be_a(String)
        expect(fill_question[:answer]).not_to be_empty
      end
    end
  end
end

RSpec.describe MeasurementsAndErrorProblemsController, type: :controller do
  let(:dummy_question) do
    {
      question: 'What is 2 + 2?',
      answer: '4',
      type: 'measurements_error',
      input_fields: [{ options: [{ value: '4' }, { value: '5' }] }]
    }
  end

  before do
    allow(MeasurementsAndErrorProblemGenerator).to receive(:new)
      .and_return(instance_double(
                    MeasurementsAndErrorProblemGenerator,
                    generate_questions: [dummy_question]
                  ))
  end

  describe 'GET #generate' do
    before { get :generate }

    it 'assigns the correct category' do
      expect(assigns(:category)).to eq('Measurement & Error')
    end

    it 'assigns the generated question' do
      expect(assigns(:question)).to eq(dummy_question)
    end

    it 'stores the question in session as JSON' do
      expect(session[:current_question]).to eq(dummy_question.to_json)
    end

    it 'renders the measurements error problem template' do
      expect(response).to render_template('practice_problems/measurements_error_problem')
    end
  end

  describe 'POST #check_answer' do
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    before do
      session[:user_id] = student.id
      session[:current_question] = dummy_question.to_json
    end

    context 'when the answer is correct' do
      before { post :check_answer, params: { measurement_answer: '4' } }

      it 'assigns the correct feedback message' do
        expect(assigns(:feedback_message)).to eq('Correct, your answer is right!')
      end

      it 'renders the measurements error problem template' do
        expect(response).to render_template('practice_problems/measurements_error_problem')
      end
    end

    context 'when the answer is incorrect' do
      before { post :check_answer, params: { measurement_answer: '5' } }

      it 'assigns an incorrect feedback message' do
        expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
      end
    end

    context 'when there is no question in session' do
      before do
        session.delete(:current_question)
        post :check_answer, params: { measurement_answer: 'any' }
      end

      it 'redirects to the generate action' do
        expect(response).to redirect_to(generate_measurements_and_error_problems_path)
      end
    end
  end

  describe 'GET #view_answer' do
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    before do
      session[:user_id] = student.id
    end

    context 'when a question exists in session' do
      before do
        session[:current_question] = dummy_question.to_json
        get :view_answer
      end

      it 'marks the answer as incorrect and shows the answer' do
        expect(assigns(:show_answer)).to be true
        expect(assigns(:disable_check_answer)).to be true
        expect(response).to render_template('practice_problems/measurements_error_problem')
      end
    end

    context 'when no question exists in session' do
      before { get :view_answer }

      it 'redirects to generate path' do
        expect(response).to redirect_to(generate_measurements_and_error_problems_path)
      end
    end
  end

  describe 'GET #generate with radio question' do
    let(:radio_question) do
      {
        question: 'Select the correct option',
        answer: 'B', # This will trigger the label_map logic
        type: 'measurements_error',
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
      allow(MeasurementsAndErrorProblemGenerator).to receive(:new)
        .and_return(instance_double(MeasurementsAndErrorProblemGenerator, generate_questions: [radio_question]))
      get :generate
    end

    it 'processes radio options and shuffles them' do
      expect(assigns(:question)[:input_fields].first[:options].size).to eq(4)
      expect(session[:current_question]).to be_present
      expect(response).to render_template('practice_problems/measurements_error_problem')
    end
  end

  describe 'POST #check_answer with radio question' do
    let(:radio_question) do
      {
        question: 'Pick one',
        answer: 'CorrectValue',
        type: 'measurements_error',
        input_fields: [
          { type: 'radio', options: [
            { value: 'WrongValue' },
            { value: 'CorrectValue' },
            { value: 'AnotherWrong' }
          ] }
        ]
      }
    end

    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'Test', last_name: 'Student', uin: '987654321')
    end

    before do
      session[:user_id] = student.id
      session[:current_question] = radio_question.to_json
    end

    it 'returns correct feedback when correct radio option is selected' do
      post :check_answer, params: { measurement_answer: 'CorrectValue' }
      expect(assigns(:feedback_message)).to match(/Correct, the answer [A-Z] is right!/)
    end

    it 'returns incorrect feedback when wrong radio option is selected' do
      post :check_answer, params: { measurement_answer: 'WrongValue' }
      expect(assigns(:feedback_message)).to eq('Incorrect, try again or press View Answer.')
    end
  end
end

# rubocop:enable RSpec/MultipleDescribes

require 'rails_helper'

RSpec.describe MeasurementsAndErrorProblemGenerator do
  let(:generator) { described_class.new('Measurements and Error') }

  describe '#initialize' do
    it 'sets the category' do
      expect(generator.instance_variable_get(:@category)).to eq('Measurements and Error')
    end
  end

  describe '#generate_questions' do
    subject(:questions) { generator.generate_questions }

    it 'returns an array of questions' do
      expect(questions).to be_an(Array)
    end

    it 'returns at least one question' do
      expect(questions.length).to be >= 1
    end

    it 'returns measurements and error questions' do
      expect(questions.first[:type]).to eq('measurements_error')
    end
  end

  describe 'generated question structure' do
    let(:question) { generator.generate_questions.first }

    it 'includes required keys' do
      expect(question).to have_key(:question)
      expect(question).to have_key(:answer)
    end

    it 'has a non-empty question' do
      expect(question[:question]).to be_a(String)
      expect(question[:question]).not_to be_empty
    end

    it 'has a valid answer option for multiple choice questions' do
      field = question[:input_fields].first
    
      if field[:type] == 'radio'
        valid_options = field[:options].map { |opt| opt[:value] }
        expect(valid_options).to include(question[:answer])
      else
        # fill‑in questions simply require a non‑nil, non‑empty answer string
        expect(question[:answer]).to be_a(String)
        expect(question[:answer]).not_to be_empty
      end
    end
    
    

    it 'includes input fields' do
      expect(question).to have_key(:input_fields)
    end
  end
end

RSpec.describe MeasurementsAndErrorProblemsController, type: :controller do
  describe 'GET #generate' do
    let(:dummy_question) do
      {
        question: "What is 2 + 2?",
        answer: "4",
        type: "measurements_error",
        input_fields: [
          { options: [{ value: "4" }, { value: "5" }] }
        ]
      }
    end

    before do
      # Stub the generator call to return a dummy question
      allow_any_instance_of(MeasurementsAndErrorProblemGenerator)
        .to receive(:generate_questions)
        .and_return([dummy_question])
      get :generate
    end

    it 'assigns the correct category' do
      expect(assigns(:category)).to eq('Measurement & Error')
    end

    it 'assigns a generated question' do
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
    let(:dummy_question) do
      {
        question: "What is 2 + 2?",
        answer: "4",
        type: "measurements_error",
        input_fields: [
          { options: [{ value: "4" }, { value: "5" }] }
        ]
      }
    end

    before do
      # Set a dummy question in the session as JSON
      session[:current_question] = dummy_question.to_json
    end

    context 'when the answer is correct' do
      before { post :check_answer, params: { measurement_answer: "4" } }

      it 'assigns the correct category' do
        expect(assigns(:category)).to eq('Measurement & Error')
      end

      it 'assigns the question from session' do
        expect(assigns(:question)).to eq(dummy_question)
      end

      it 'sets a correct feedback message' do
        expect(assigns(:feedback_message)).to eq('Correct, your answer is right!')
      end

      it 'renders the measurements error problem template' do
        expect(response).to render_template('practice_problems/measurements_error_problem')
      end
    end

    context 'when the answer is incorrect' do
      before { post :check_answer, params: { measurement_answer: "5" } }

      it 'assigns the correct category' do
        expect(assigns(:category)).to eq('Measurement & Error')
      end

      it 'assigns the question from session' do
        expect(assigns(:question)).to eq(dummy_question)
      end

      it 'sets an incorrect feedback message' do
        expect(assigns(:feedback_message)).to eq("Incorrect, the correct answer is #{dummy_question[:answer]}.")
      end

      it 'renders the measurements error problem template' do
        expect(response).to render_template('practice_problems/measurements_error_problem')
      end
    end

    context 'when there is no question in session' do
      before do
        session[:current_question] = nil
        post :check_answer, params: { measurement_answer: "any" }
      end

      it 'redirects to the generate action' do
        expect(response).to redirect_to(generate_measurements_and_error_problems_path)
      end
    end
  end
end

# spec/controllers/practice_problems_controller_spec.rb
require 'rails_helper'

RSpec.describe PracticeProblemsController, type: :controller do
  describe 'GET #index' do
    # Create a question with a category string so that it appears in the unique list.
    let!(:question) { Question.create!(category: 'Test Category', question: 'Sample question') }

    before do
      get :index
    end

    it 'includes the newly created category in assigns(:categories)' do
      categories = assigns(:categories)
      expect(categories).to include('Test Category')
    end

    it 'renders the :index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #generate' do
    let(:category) { 'Math' }
    let(:questions) do
      [
        { question: 'Q1', answer_choices: %w[A B], answer: 'A' },
        { question: 'Q2', answer_choices: %w[C D], answer: 'C' }
      ]
    end

    let(:problem_generator) { instance_double(ProblemGenerator) }

    before do
      # Expect the generator to be initialized with the category string.
      allow(ProblemGenerator).to receive(:new).with(category).and_return(problem_generator)
    end

    context 'when there is no last question in the session' do
      before do
        allow(problem_generator).to receive(:generate_questions).and_return(questions)
        get :generate, params: { category_id: category }
      end

      it 'picks a random question' do
        expect(questions).to include(assigns(:question))
      end

      it 'stores the question in the session as JSON' do
        parsed_question = JSON.parse(session[:current_question], symbolize_names: true)
        expect(parsed_question).to eq(assigns(:question))
      end

      it 'renders the :generate template' do
        expect(response).to render_template(:generate)
      end
    end

    context 'when multiple questions exist and a last question is in the session' do
      before do
        session[:last_question] = 'Q1'
        allow(problem_generator).to receive(:generate_questions).and_return(questions)
        get :generate, params: { category_id: category }
      end

      it 'filters out Q1 and picks Q2' do
        expect(assigns(:question)[:question]).to eq('Q2')
      end

      it 'stores the selected question in session as JSON' do
        parsed_question = JSON.parse(session[:current_question], symbolize_names: true)
        expect(parsed_question[:question]).to eq('Q2')
      end

      it 'renders the :generate template' do
        expect(response).to render_template(:generate)
      end
    end

    context 'when only one question exists and a last question is in the session' do
      before do
        session[:last_question] = 'Q1'
        allow(problem_generator).to receive(:generate_questions).and_return([questions.first])
        get :generate, params: { category_id: category }
      end

      it 'does NOT filter out Q1 since only one question is available' do
        expect(assigns(:question)[:question]).to eq('Q1')
      end

      it 'stores the question in session as JSON' do
        parsed_question = JSON.parse(session[:current_question], symbolize_names: true)
        expect(parsed_question[:question]).to eq('Q1')
      end

      it 'renders the :generate template' do
        expect(response).to render_template(:generate)
      end
    end
  end

  describe 'GET #generate for Experimental Statistics' do
    let(:category) { 'Experimental Statistics' }
    let(:statistics_generator) { instance_double(StatisticsProblemGenerator) }
    let(:prob_question) do
      {
        type: 'probability',
        question: 'Probability question example',
        answer: 50.0,
        input_fields: nil
      }
    end
    let(:data_question) do
      {
        type: 'data_statistics',
        question: 'Data statistics question',
        data_table: [[1.0, 2.0], [3.0, 4.0]],
        answers: { mean: 2.5, median: 2.5, mode: 1.0, range: 3.0, std_dev: 1.29, variance: 1.67 },
        input_fields: [
          { label: 'Mean', key: 'mean' },
          { label: 'Median', key: 'median' }
        ]
      }
    end

    before do
      allow(StatisticsProblemGenerator).to receive(:new).with(category).and_return(statistics_generator)
      allow(statistics_generator).to receive(:generate_questions).and_return([prob_question, data_question])
    end

    context 'when there is no previous problem type in session' do
      before do
        get :generate, params: { category_id: category }
      end

      it 'selects a probability problem' do
        expect(assigns(:question)[:type]).to eq('probability')
      end

      it 'sets the last problem type in session' do
        expect(session[:last_problem_type]).to eq('probability')
      end

      it 'renders the generate template' do
        expect(response).to render_template(:generate)
      end
    end

    context 'when the last problem was probability type' do
      before do
        session[:last_problem_type] = 'probability'
        get :generate, params: { category_id: category }
      end

      it 'selects a data statistics problem' do
        expect(assigns(:question)[:type]).to eq('data_statistics')
      end

      it 'updates the last problem type in session' do
        expect(session[:last_problem_type]).to eq('data_statistics')
      end
    end
  end

  describe 'POST #check_answer with probability questions' do
    let(:category) { 'Experimental Statistics' }

    before do
      question = {
        type: 'probability',
        question: 'What is the probability?',
        answer: 75.25,
        input_fields: nil
      }
      session[:current_question] = question.to_json
    end

    it 'redirects to generate with success parameter when answer is correct' do
      post :check_answer, params: { category_id: category, answer: '75.25' }
      expect(response).to redirect_to(generate_practice_problems_path(category_id: category, success: true))
    end

    it 'sets an error message when answer is too small' do
      post :check_answer, params: { category_id: category, answer: '50.0' }
      expect(assigns(:error_message)).to eq('too small')
    end

    it 'renders the generate template when answer is wrong' do
      post :check_answer, params: { category_id: category, answer: '50.0' }
      expect(response).to render_template(:generate)
    end
  end

  describe 'POST #check_answer with data statistics questions' do
    let(:category) { 'Experimental Statistics' }

    before do
      question = {
        type: 'data_statistics',
        question: 'Calculate statistics',
        data_table: [[1.0, 2.0], [3.0, 4.0]],
        answers: { mean: 2.5, median: 2.5 },
        input_fields: [
          { label: 'Mean', key: 'mean' },
          { label: 'Median', key: 'median' }
        ]
      }
      session[:current_question] = question.to_json
    end

    it 'redirects to generate with success parameter when all answers are correct' do
      params = { category_id: category, mean: '2.5', median: '2.5' }
      post :check_answer, params: params
      expected_path = generate_practice_problems_path(category_id: category, success: true)
      expect(response).to redirect_to(expected_path)
    end

    it 'sets an error message when mean is wrong' do
      params = { category_id: category, mean: '3.0', median: '2.5' }
      post :check_answer, params: params
      expect(assigns(:error_message)).to include('mean')
    end

    it 'renders the generate template when an answer is wrong' do
      params = { category_id: category, mean: '3.0', median: '2.5' }
      post :check_answer, params: params
      expect(response).to render_template(:generate)
    end
  end
end

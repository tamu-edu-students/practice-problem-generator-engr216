# spec/controllers/practice_problems_controller_spec.rb
require 'rails_helper'

RSpec.describe PracticeProblemsController, type: :controller do
  describe 'GET #index' do
    # Create a question with a category string so that it appears in the unique list.
    # let!(:question) { Question.create!(category: 'Test Category', question: 'Sample question') }

    before do
      get :index
    end

    it 'includes the newly created category in assigns(:categories)' do
      Question.create!(question: 'Test question', category: 'Test Category', answer_choices: ['42'])
      get :index
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

  describe 'GET #generate for Confidence Intervals' do
    let(:category) { 'Confidence Intervals' }
    let(:confidence_interval_generator) { instance_double(ConfidenceIntervalProblemGenerator) }
    let(:ci_question) do
      {
        type: 'confidence_interval',
        question: 'Construct a confidence interval...',
        answers: {
          lower_bound: 95.43,
          upper_bound: 104.57
        },
        input_fields: [
          { label: 'Lower Bound', key: 'lower_bound' },
          { label: 'Upper Bound', key: 'upper_bound' }
        ]
      }
    end

    before do
      # The constructor takes a category parameter
      allow(ConfidenceIntervalProblemGenerator).to receive(:new).with(category)
                                                                .and_return(confidence_interval_generator)
      allow(confidence_interval_generator).to receive(:generate_questions)
        .and_return([ci_question])
      get :generate, params: { category_id: category }
    end

    it 'selects a confidence interval problem' do
      expect(assigns(:question)[:type]).to eq('confidence_interval')
    end

    it 'includes the appropriate answer fields' do
      expect(assigns(:question)[:answers]).to include(:lower_bound, :upper_bound)
    end

    it 'stores the question in the session as JSON' do
      parsed_question = JSON.parse(session[:current_question], symbolize_names: true)
      expect(parsed_question[:type]).to eq('confidence_interval')
    end

    it 'renders the generate template' do
      expect(response).to render_template(:generate)
    end
  end

  describe 'POST #check_answer with confidence interval questions' do
    let(:category) { 'Confidence Intervals' }

    before do
      question = {
        type: 'confidence_interval',
        question: 'A city measures the daily water usage of 50 water samples, ' \
                  'with a sample mean concentration of 125.5. ' \
                  'Assume the population standard deviation is 18.2, ' \
                  'and water usage is normally distributed. ' \
                  'Construct a 95% confidence interval.',
        answers: {
          lower_bound: 120.45,
          upper_bound: 130.55
        },
        input_fields: [
          { label: 'Lower Bound', key: 'lower_bound' },
          { label: 'Upper Bound', key: 'upper_bound' }
        ]
      }
      session[:current_question] = question.to_json
    end

    it 'redirects to generate with success parameter when both bounds are correct' do
      params = { category_id: category, lower_bound: '120.45', upper_bound: '130.55' }
      post :check_answer, params: params
      expected_path = generate_practice_problems_path(category_id: category, success: true)
      expect(response).to redirect_to(expected_path)
    end

    it 'sets an error message when lower bound is wrong' do
      params = { category_id: category, lower_bound: '90.0', upper_bound: '104.57' }
      post :check_answer, params: params
      expect(assigns(:error_message)).to include('lower bound')
    end

    it 'sets an error message when upper bound is wrong' do
      # Make sure lower bound is correct so it checks upper bound
      post :check_answer, params: { category_id: category, lower_bound: '120.45', upper_bound: '140.0' }
      expect(assigns(:error_message)).to include('upper bound')
    end

    it 'sets an error message when lower bound is blank' do
      params = { category_id: category, lower_bound: '', upper_bound: '104.57' }
      post :check_answer, params: params
      expect(assigns(:error_message)).to include('please provide a value for lower bound')
    end

    it 'sets an error message when upper bound is blank' do
      params = { category_id: category, lower_bound: '95.43', upper_bound: '' }
      post :check_answer, params: params
      expect(assigns(:error_message)).to include('please provide a value for upper bound')
    end

    it 'renders the generate template when an answer is wrong' do
      params = { category_id: category, lower_bound: '90.0', upper_bound: '104.57' }
      post :check_answer, params: params
      expect(response).to render_template(:generate)
    end

    it 'accounts for rounding within 0.01' do
      # Test exact 0.01 difference for both bounds
      post :check_answer,
           params: { category_id: category, lower_bound: (120.45 - 0.01).to_s, upper_bound: (130.55 + 0.01).to_s }
      expected_path = generate_practice_problems_path(category_id: category, success: true)
      expect(response).to redirect_to(expected_path)
    end
  end

  describe '#process_answer_for_question_type' do
    let(:category) { 'Confidence Intervals' }

    it 'handles missing question data' do
      session[:current_question] = nil
      post :check_answer, params: { category_id: category }
      expect(response).to redirect_to(generate_practice_problems_path(category_id: category))
    end

    it 'handles malformed JSON in the session' do
      session[:current_question] = '{invalid_json:'
      post :check_answer, params: { category_id: category }
      expect(response).to redirect_to(generate_practice_problems_path(category_id: category))
    end

    it 'handles unknown question types' do
      question = { type: 'unknown_type', question: 'What is this?' }
      session[:current_question] = question.to_json
      post :check_answer, params: { category_id: category }
      expect(response).to render_template(:generate)
    end
  end

  describe 'handle_confidence_interval_problem' do
    let(:category) { 'Confidence Intervals' }
    let(:confidence_interval_generator) { instance_double(ConfidenceIntervalProblemGenerator) }
    let(:ci_question) { { type: 'confidence_interval', question: 'Test CI question' } }

    before do
      # The constructor takes a category parameter
      allow(ConfidenceIntervalProblemGenerator).to receive(:new).with(category)
                                                                .and_return(confidence_interval_generator)
      allow(confidence_interval_generator).to receive(:generate_questions)
        .and_return([ci_question])
      get :generate, params: { category_id: category }
    end

    it 'assigns the generated question' do
      expect(assigns(:question)).to eq(ci_question)
    end
  end

  describe 'set_error_message' do
    it 'formats error message for string keys' do
      controller.send(:set_error_message, 'mean', 5.0, 4.0)
      expect(assigns(:error_message)).to eq('your mean is too high (correct answer: 4.0)')
    end

    it 'formats error message for symbol keys' do
      controller.send(:set_error_message, :standard_deviation, 3.0, 4.0)
      expect(assigns(:error_message)).to eq('your standard deviation is too low (correct answer: 4.0)')
    end

    it 'handles multi-word keys with humanize' do
      controller.send(:set_error_message, 'lower_bound', 2.0, 3.0)
      expect(assigns(:error_message)).to eq('your lower bound is too low (correct answer: 3.0)')
    end
  end

  describe 'check_confidence_interval_answers additional testing' do
    let(:category) { 'Confidence Intervals' }

    before do
      question = {
        type: 'confidence_interval',
        question: 'A city measures the daily water usage of 50 water samples, ' \
                  'with a sample mean concentration of 125.5. ' \
                  'Assume the population standard deviation is 18.2, ' \
                  'and water usage is normally distributed. ' \
                  'Construct a 95% confidence interval.',
        answers: {
          lower_bound: 120.45,
          upper_bound: 130.55
        },
        input_fields: [
          { label: 'Lower Bound', key: 'lower_bound' },
          { label: 'Upper Bound', key: 'upper_bound' }
        ]
      }
      session[:current_question] = question.to_json
    end

    it 'includes debug info for extracted parameters' do
      post :check_answer, params: { category_id: category, lower_bound: '120.45', upper_bound: '130.55' }
      expect(session[:debug_info]).to include('Extracted parameters')
    end

    it 'accepts values that are very close but not exact' do
      post :check_answer, params: { category_id: category, lower_bound: '120.44', upper_bound: '130.56' }
      expect(response).to redirect_to(generate_practice_problems_path(category_id: category, success: true))
    end
  end

  describe 'checking confidence interval water usage answers' do
    let(:category) { 'Confidence Intervals' }
    let(:question_text) do
      'A city measures the daily water usage of 50 water samples, ' \
        'with a sample mean concentration of 125.5. ' \
        'Assume the population standard deviation is 18.2, ' \
        'and water usage is normally distributed. ' \
        'Construct a 95% confidence interval.'
    end

    before do
      question = {
        type: 'confidence_interval',
        question: question_text,
        answers: {
          lower_bound: 120.45,
          upper_bound: 130.55
        },
        input_fields: [
          { label: 'Lower Bound', key: 'lower_bound' },
          { label: 'Upper Bound', key: 'upper_bound' }
        ]
      }
      session[:current_question] = question.to_json
    end

    it 'includes extracted parameters in debug info' do
      post :check_answer, params: { category_id: category, lower_bound: '120.45', upper_bound: '130.55' }
      expect(session[:debug_info]).to include('Extracted parameters')
    end
  end
end

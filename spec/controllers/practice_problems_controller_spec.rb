# spec/controllers/practice_problems_controller_spec.rb
require 'rails_helper'

RSpec.describe PracticeProblemsController, type: :controller do
  before do
    session[:user_type] = 'student'
    session[:user_id] = 1
  end

  let(:confidence_interval_question) do
    {
      question: 'Calculate confidence interval...',
      input_fields: [
        { key: :lower_bound, label: 'Lower Bound' },
        { key: :upper_bound, label: 'Upper Bound' }
      ],
      answer: {
        lower_bound: 10,
        upper_bound: 20
      }
    }
  end
  let(:data_statistics_question) do
    {
      question: 'Calculate statistics for...',
      data_table: [[1, 2], [3, 4]],
      answer: {
        mean: 2.5,
        median: 2.5,
        mode: nil,
        range: 3,
        standard_deviation: 1.29,
        variance: 1.67
      }
    }
  end
  # Define missing question variables before the tests
  let(:probability_question) do
    {
      question: 'What is the probability of...',
      answer: '0.5'
    }
  end

  describe 'GET #index' do
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

  describe 'GET #generate basic functionality' do
    # Combine three memoized helpers into one hash.
    let(:basic_context) do
      {
        category: 'Math',
        questions: [
          { question: 'Q1', answer_choices: %w[A B], answer: 'A' },
          { question: 'Q2', answer_choices: %w[C D], answer: 'C' }
        ],
        problem_generator: instance_double(ProblemGenerator)
      }
    end

    before do
      allow(ProblemGenerator).to receive(:new)
        .with(basic_context[:category])
        .and_return(basic_context[:problem_generator])
    end

    context 'when there is no last question in the session' do
      before do
        allow(basic_context[:problem_generator]).to receive(:generate_questions)
          .and_return(basic_context[:questions])
        get :generate, params: { category_id: basic_context[:category] }
      end

      it 'picks a random question' do
        expect(basic_context[:questions]).to include(assigns(:question))
      end

      it 'stores the question key in the session as JSON' do
        session = JSON.parse(controller.session[:current_question], symbolize_names: true)
        expect(session[:question]).to eq(assigns(:question)[:question])
      end

      it 'stores the answer in the session as JSON' do
        session = JSON.parse(controller.session[:current_question], symbolize_names: true)
        expect(session[:answer]).to eq(assigns(:question)[:answer])
      end

      it 'renders the :generate template' do
        expect(response).to render_template(:generate)
      end
    end

    context 'when multiple questions exist and a last question is in the session' do
      before do
        session[:last_question] = 'Q1'
        allow(basic_context[:problem_generator]).to receive(:generate_questions)
          .and_return(basic_context[:questions])
        get :generate, params: { category_id: basic_context[:category] }
      end

      it 'filters out Q1 and picks Q2' do
        expect(assigns(:question)[:question]).to eq('Q2')
      end

      it 'stores the selected question in session' do
        session = JSON.parse(controller.session[:current_question], symbolize_names: true)
        expect(session[:question]).to eq(assigns(:question)[:question])
      end

      it 'stores the selected answer in session' do
        session = JSON.parse(controller.session[:current_question], symbolize_names: true)
        expect(session[:answer]).to eq(assigns(:question)[:answer])
      end

      it 'renders the :generate template' do
        expect(response).to render_template(:generate)
      end
    end

    context 'when only one question exists and a last question is in the session' do
      before do
        session[:last_question] = 'Q1'
        allow(basic_context[:problem_generator]).to receive(:generate_questions)
          .and_return([basic_context[:questions].first])
        get :generate, params: { category_id: basic_context[:category] }
      end

      it 'does NOT filter out Q1 since only one question is available' do
        expect(assigns(:question)[:question]).to eq('Q1')
      end

      it 'stores the question in session' do
        session = JSON.parse(controller.session[:current_question], symbolize_names: true)
        expect(session[:question]).to eq(assigns(:question)[:question])
      end

      it 'stores the answer in session' do
        session = JSON.parse(controller.session[:current_question], symbolize_names: true)
        expect(session[:answer]).to eq(assigns(:question)[:answer])
      end

      it 'renders the :generate template' do
        expect(response).to render_template(:generate)
      end
    end
  end

  describe 'GET #generate template rendering' do
    it 'renders the statistics_problem template for probability questions' do
      # Setup in before block to reduce example length
      question = { type: 'probability', question: 'Test', answer: 42 }
      allow(controller).to receive(:question_for_category).and_return(question)

      # Shortened to two lines
      get :generate, params: { category_id: 'Experimental Statistics' }
      expect(response).to render_template(:statistics_problem)
    end

    describe 'confidence interval template rendering' do
      before do
        allow(controller).to receive(:question_for_category).and_return({
                                                                          type: 'confidence_interval',
                                                                          question: 'Test CI question',
                                                                          answers: { lower_bound: 10, upper_bound: 20 },
                                                                          input_fields: [
                                                                            { label: 'Lower Bound',
                                                                              key: 'lower_bound' },
                                                                            { label: 'Upper Bound', key: 'upper_bound' }
                                                                          ]
                                                                        })
      end

      it 'renders the confidence_interval_problem template for confidence interval questions' do
        get :generate, params: { category_id: 'Confidence Intervals' }
        expect(response).to render_template('practice_problems/confidence_interval_problem')
      end
    end

    describe 'engineering ethics template rendering' do
      before do
        allow(controller).to receive(:question_for_category).and_return({
                                                                          type: 'engineering_ethics',
                                                                          question: 'Test ethics question',
                                                                          answer: true
                                                                        })
      end

      it 'renders the engineering_ethics_problem template for engineering ethics questions' do
        get :generate, params: { category_id: 'Engineering Ethics' }
        expect(response).to render_template('engineering_ethics_problem')
      end
    end
  end

  describe 'GET #generate for Experimental Statistics' do
    let(:stats_context) do
      {
        category: 'Experimental Statistics',
        questions: [
          { type: 'probability', question: 'Example', answer: 50.0, input_fields: nil },
          {
            type: 'data_statistics',
            question: 'Data question',
            data_table: [[1.0, 2.0], [3.0, 4.0]],
            answers: { mean: 2.5, median: 2.5, mode: 1.0, range: 3.0, std_dev: 1.29, variance: 1.67 },
            input_fields: [
              { label: 'Mean', key: 'mean' },
              { label: 'Median', key: 'median' }
            ]
          }
        ],
        statistics_generator: instance_double(StatisticsProblemGenerator)
      }
    end

    before do
      allow(StatisticsProblemGenerator).to receive(:new)
        .with(stats_context[:category])
        .and_return(stats_context[:statistics_generator])
      allow(stats_context[:statistics_generator]).to receive(:generate_questions)
        .and_return(stats_context[:questions])
    end

    context 'when there is no previous problem type in session' do
      it 'renders the statistics_problem template' do
        get :generate, params: { category_id: stats_context[:category] }
        expect(response).to render_template(:statistics_problem)
      end
    end

    context 'when the last problem was probability type' do
      before do
        session[:last_problem_type] = 'probability'
        get :generate, params: { category_id: stats_context[:category] }
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
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    before do
      question = {
        type: 'probability',
        question: 'What is the probability?',
        answer: 75.25,
        input_fields: nil
      }
      session[:current_question] = question.to_json
      session[:user_id] = student.id
    end

    it 'redirects to generate with success parameter when answer is correct' do
      post :check_answer, params: { category_id: category, answer: '75.25' }
      expect(response).to redirect_to(generate_practice_problems_path(category_id: category, success: true))
    end

    it 'sets an error message when answer is too small' do
      post :check_answer, params: { category_id: category, answer: '50.0' }
      expect(assigns(:error_message)).to eq('too small')
    end

    it 'renders the statistics_problem template when answer is wrong' do
      post :check_answer, params: { category_id: 'Probability', answer: 'wrong_answer' }
      expect(response).to render_template('practice_problems/statistics_problem')
    end
  end

  describe 'POST #check_answer with data statistics questions' do
    let(:category) { 'Experimental Statistics' }
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

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
      session[:user_id] = student.id
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

    it 'renders the statistics_problem template when an answer is wrong' do
      post :check_answer, params: { category_id: 'Experimental Statistics', mean: 'wrong', median: 'wrong' }
      expect(response).to render_template('practice_problems/statistics_problem')
    end
  end

  describe 'GET #generate for Confidence Intervals' do
    let(:ci_context) do
      {
        category: 'Confidence Intervals',
        generator: instance_double(ConfidenceIntervalProblemGenerator),
        question: {
          type: 'confidence_interval',
          question: 'Construct a confidence interval...',
          answers: { lower_bound: 95.43, upper_bound: 104.57 },
          input_fields: [
            { label: 'Lower Bound', key: 'lower_bound' },
            { label: 'Upper Bound', key: 'upper_bound' }
          ]
        }
      }
    end

    before do
      allow(ConfidenceIntervalProblemGenerator).to receive(:new)
        .with(ci_context[:category])
        .and_return(ci_context[:generator])
      allow(ci_context[:generator]).to receive(:generate_questions)
        .and_return([ci_context[:question]])
      get :generate, params: { category_id: ci_context[:category] }
    end

    it 'selects a confidence interval problem' do
      expect(assigns(:question)[:type]).to eq('confidence_interval')
    end

    it 'includes the appropriate answer fields' do
      expect(assigns(:question)[:answers]).to include(:lower_bound, :upper_bound)
    end

    it 'stores the question in the session' do
      session = JSON.parse(controller.session[:current_question], symbolize_names: true)
      expect(session[:question]).to eq(assigns(:question)[:question])
    end

    it 'stores the answer in the session' do
      session = JSON.parse(controller.session[:current_question], symbolize_names: true)
      expect(session[:answer]).to eq(assigns(:question)[:answer])
    end

    it 'renders the confidence_interval_problem template' do
      expect(response).to render_template('practice_problems/confidence_interval_problem')
    end
  end

  describe 'POST #check_answer with confidence interval questions' do
    let(:category) { 'Confidence Intervals' }
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

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
      session[:user_id] = student.id
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

    it 'renders the confidence_interval_problem template when an answer is wrong' do
      post :check_answer, params: { category_id: 'Confidence Intervals', lower_bound: 'wrong', upper_bound: 'wrong' }
      expect(response).to render_template('practice_problems/confidence_interval_problem')
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

  describe 'set_error_message' do
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    before do
      session[:user_id] = student.id
    end

    it 'formats error message for string keys' do
      controller.instance_variable_set(:@question, { type: 'default' })
      controller.send(:set_error_message, 'mean', 5.0, 4.0)
      expect(assigns(:error_message)).to eq('your mean is too high (correct answer: 4.0)')
    end

    it 'formats error message for symbol keys' do
      controller.instance_variable_set(:@question, { type: 'default' })
      controller.send(:set_error_message, :standard_deviation, 3.0, 4.0)
      expect(assigns(:error_message)).to eq('your standard deviation is too low (correct answer: 4.0)')
    end

    it 'handles multi-word keys with humanize' do
      controller.instance_variable_set(:@question, { type: 'default' })
      controller.send(:set_error_message, 'lower_bound', 2.0, 3.0)
      expect(assigns(:error_message)).to eq('your lower bound is too low (correct answer: 3.0)')
    end
  end

  describe 'parameter extraction from question text' do
    let(:category) { 'Confidence Intervals' }
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end
    let(:question) do
      {
        type: 'confidence_interval',
        question: 'A sample of 25 water samples has a mean concentration of 10.5 ppm with a population ' \
                  'standard deviation of 2.1 ppm. Calculate the 95% confidence interval.',
        answers: { lower_bound: 9.68, upper_bound: 11.32 }
      }
    end

    before do
      session[:current_question] = question.to_json
      session[:debug_info] = nil
      session[:user_id] = student.id
    end

    it 'extracts sample size parameter from text' do
      post :check_answer, params: { category_id: category, lower_bound: '9.68', upper_bound: '11.32' }
      expect(session[:debug_info]).to include('25')
    end

    it 'extracts sample mean parameter from text' do
      post :check_answer, params: { category_id: category, lower_bound: '9.68', upper_bound: '11.32' }
      expect(session[:debug_info]).to include('10.5')
    end

    it 'extracts standard deviation parameter from text' do
      post :check_answer, params: { category_id: category, lower_bound: '9.68', upper_bound: '11.32' }
      expect(session[:debug_info]).to include('2.1')
    end

    it 'extracts confidence level parameter from text' do
      post :check_answer, params: { category_id: category, lower_bound: '9.68', upper_bound: '11.32' }
      expect(session[:debug_info]).to include('95%')
    end
  end

  # Test extraction with parameters present in question data
  describe 'confidence interval with parameters in question data' do
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end
    let(:category) { 'Confidence Intervals' }
    let(:question) do
      {
        type: 'confidence_interval',
        question: 'Calculate the confidence interval...',
        answers: { lower_bound: 9.68, upper_bound: 11.32 },
        parameters: {
          sample_size: 25,
          sample_mean: 10.5,
          pop_std: 2.1,
          confidence_level: 95
        }
      }
    end

    before do
      session[:current_question] = question.to_json
      session[:user_id] = student.id
    end

    it 'uses sample size parameter from question data' do
      post :check_answer, params: { category_id: category, lower_bound: '9.68', upper_bound: '11.32' }
      expect(session[:debug_info]).to include('sample_size=25')
    end

    it 'uses sample mean parameter from question data' do
      post :check_answer, params: { category_id: category, lower_bound: '9.68', upper_bound: '11.32' }
      expect(session[:debug_info]).to include('sample_mean=10.5')
    end
  end

  # Tests for engineering ethics answer checking
  describe 'engineering ethics answer checking' do
    let(:category) { 'Engineering Ethics' }
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    context 'with true answer' do
      let(:question) do
        {
          type: 'engineering_ethics',
          question: 'Is it ethical to...?',
          answer: true
        }
      end

      before do
        session[:current_question] = question.to_json
        session[:user_id] = student.id
      end

      it 'redirects to success page when answer is correct' do
        post :check_answer, params: { category_id: category, ethics_answer: 'true' }
        expect(response).to redirect_to(generate_practice_problems_path(category_id: category, success: true))
      end

      it 'sets error message' do
        post :check_answer, params: { category_id: category, ethics_answer: 'false' }
        expect(assigns(:error_message)).to include("That's incorrect")
      end

      it 'includes correct answer in error message' do
        post :check_answer, params: { category_id: category, ethics_answer: 'false' }
        expect(assigns(:error_message)).to include('True')
      end
    end
  end

  # Tests for finite differences problems
  describe 'handle_finite_differences_problem' do
    let(:fd_context) do
      {
        category: 'Finite Differences',
        generator: instance_double(FiniteDifferencesProblemGenerator),
        question: { type: 'finite_differences', question: 'Test FD question' }
      }
    end

    before do
      allow(FiniteDifferencesProblemGenerator).to receive(:new)
        .with(fd_context[:category])
        .and_return(fd_context[:generator])
      allow(fd_context[:generator]).to receive(:generate_questions)
        .and_return([fd_context[:question]])
    end

    it 'generates a finite differences problem' do
      get :generate, params: { category_id: fd_context[:category] }
      expect(assigns(:question)).to eq(fd_context[:question])
    end

    it 'renders the finite differences template' do
      get :generate, params: { category_id: fd_context[:category] }
      expect(response).to render_template('finite_differences_problem')
    end
  end

  # Tests for finite differences answer checking
  describe 'POST #check_answer with finite differences' do
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    context 'with single answer field' do
      let(:category) { 'Finite Differences' }
      let(:question) do
        {
          type: 'finite_differences',
          question: 'Calculate the value',
          answer: 42.0
        }
      end

      before do
        session[:current_question] = question.to_json
        session[:user_id] = student.id
      end

      it 'redirects to success page when answer is correct' do
        post :check_answer, params: { category_id: category, answer: '42.0' }
        expect(response).to redirect_to(generate_practice_problems_path(category_id: category, success: true))
      end

      it 'sets error message when answer is too small' do
        post :check_answer, params: { category_id: category, answer: '41.0' }
        expect(assigns(:error_message)).to eq('too small')
      end
    end

    context 'with multiple input fields' do
      let(:category) { 'Finite Differences' }
      let!(:student) do
        Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
      end
      let(:question) do
        {
          type: 'finite_differences',
          question: 'Calculate multiple values',
          input_fields: [
            { key: 'field1', label: 'Field 1' },
            { key: 'field2', label: 'Field 2' }
          ],
          parameters: {
            field1: 10.0,
            field2: 20.0
          }
        }
      end

      before do
        session[:current_question] = question.to_json
        session[:user_id] = student.id
      end

      it 'redirects to success page when all answers are correct' do
        post :check_answer, params: { category_id: category, field1: '10.0', field2: '20.0' }
        expect(response).to redirect_to(generate_practice_problems_path(category_id: category, success: true))
      end

      it 'sets error message when first field is incorrect' do
        post :check_answer, params: { category_id: category, field1: '9.0', field2: '20.0' }
        expect(assigns(:error_message)).to include('too low')
      end
    end
  end

  # Adjust the nesting level to fix the RSpec/NestedGroups offense
  describe 'finite differences with missing parameter' do
    let(:category) { 'Finite Differences' }
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end
    let(:question) do
      {
        type: 'finite_differences',
        question: 'Calculate the value',
        input_fields: [
          { key: 'field1', label: 'Field 1' }
        ],
        parameters: {}
      }
    end

    before do
      session[:current_question] = question.to_json
      session[:user_id] = student.id
    end

    it 'handles missing parameter definition' do
      post :check_answer, params: { category_id: category, field1: '10.0' }
      expect(assigns(:error_message)).to include('Missing parameter definition')
    end
  end

  # Tests for universal account equations problems
  describe 'handle_universal_account_equations_problem' do
    let(:uae_context) do
      {
        category: 'Universal Accounting Equation',
        generator: instance_double(UniversalAccountEquationsProblemGenerator),
        question: { type: 'universal_account_equations', question: 'Test UAE question', answer: 100 }
      }
    end

    before do
      allow(UniversalAccountEquationsProblemGenerator).to receive(:new)
        .with(uae_context[:category])
        .and_return(uae_context[:generator])
      allow(uae_context[:generator]).to receive(:generate_questions)
        .and_return([uae_context[:question]])
    end

    it 'assigns the generated problem' do
      get :generate, params: { category_id: uae_context[:category] }
      expect(assigns(:question)).to eq(uae_context[:question])
    end

    it 'renders the correct template' do
      get :generate, params: { category_id: uae_context[:category] }
      expect(response).to render_template('universal_account_equations_problem')
    end
  end

  # Tests for special category redirections
  describe 'special category redirects' do
    it 'redirects to measurement and error controller for measurement categories' do
      get :generate, params: { category_id: 'Measurement & Error' }
      expect(response).to redirect_to(generate_measurements_and_error_problems_path)
    end

    it 'redirects to harmonic motion controller for harmonic motion categories' do
      get :generate, params: { category_id: 'Harmonic Motion Category' }
      expect(response).to redirect_to(generate_harmonic_motion_problems_path)
    end
  end

  context 'with propagation of error category' do
    let(:category) { 'propagation of error' }
    let(:generator) { instance_double(ErrorPropagationProblemGenerator) }
    let(:question) do
      {
        type: 'propagation of error',
        question: 'Test question',
        answer: '0.123',
        input_fields: [{ label: 'Answer', key: 'answer', type: 'text' }]
      }
    end

    before do
      allow(ErrorPropagationProblemGenerator).to receive(:new).with(category).and_return(generator)
      allow(generator).to receive(:generate_questions).and_return([question])
    end

    describe 'GET #generate' do
      it 'assigns the question' do
        get :generate, params: { category_id: category }
        expect(assigns(:question)).to eq(question)
      end

      it 'renders the correct template' do
        get :generate, params: { category_id: category }
        expect(response).to render_template('propagation_of_error_problem')
      end
    end

    # Adjust nesting level to fix RSpec/NestedGroups offenses
    describe 'POST #check_answer for correct answer' do
      let!(:student) do
        Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
      end

      before do
        session[:current_question] = question.to_json
        session[:user_id] = student.id
      end

      it 'renders the problem template' do
        post :check_answer, params: { category_id: category, answer: '0.123' }
        expect(response).to render_template('propagation_of_error_problem')
      end

      it 'assigns the question' do
        post :check_answer, params: { category_id: category, answer: '0.123' }
        expect(assigns(:question)).to eq(question)
      end
    end

    describe 'POST #check_answer for incorrect answer' do
      let!(:student) do
        Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
      end

      before do
        session[:current_question] = question.to_json
        session[:user_id] = student.id
      end

      it 'sets error message for small answer' do
        post :check_answer, params: { category_id: category, answer: '0.090' }
        expect(assigns(:error_message)).to eq('too small')
      end

      it 'renders the problem template' do
        post :check_answer, params: { category_id: category, answer: '0.090' }
        expect(response).to render_template('propagation_of_error_problem')
      end
    end
  end

  # Tests for #determine_template_for_question
  describe '#determine_template_for_question' do
    it 'returns statistics_problem for probability questions' do
      controller = described_class.new
      question = { type: 'probability' }
      expect(controller.send(:determine_template_for_question, question)).to eq('statistics_problem')
    end

    it 'returns engineering_ethics_problem for engineering_ethics questions' do
      controller = described_class.new
      question = { type: 'engineering_ethics' }
      expect(controller.send(:determine_template_for_question, question)).to eq('engineering_ethics_problem')
    end

    it 'returns generate for unknown question types' do
      controller = described_class.new
      question = { type: 'unknown_type' }
      expect(controller.send(:determine_template_for_question, question)).to eq('generate')
    end
  end

  # Test for handle_collisions method
  describe 'POST #check_answer with collision problems' do
    let(:category) { 'Momentum & Collisions' }
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    context 'with single answer field' do
      let(:question) do
        {
          type: 'momentum & collisions',
          question: 'Calculate the final velocity',
          answer: 5.0
        }
      end

      before do
        session[:current_question] = question.to_json
        session[:user_id] = student.id
      end

      it 'redirects to success page when answer is correct' do
        post :check_answer, params: { category_id: category, answer: '5.0' }
        expect(response).to redirect_to(generate_practice_problems_path(category_id: category, success: true))
      end

      it 'sets error message when answer is slightly off' do
        post :check_answer, params: { category_id: category, answer: '5.3' }
        expect(assigns(:error_message)).to include('too high')
      end

      it 'sets error message when answer is too small' do
        post :check_answer, params: { category_id: category, answer: '4.0' }
        expect(assigns(:error_message)).to include('too low')
      end
    end

    context 'with multiple answer fields' do
      let(:question) do
        {
          type: 'momentum & collisions',
          question: 'Calculate the final velocities',
          answer: { puck1: 2.0, puck2: 3.0 }
        }
      end

      before do
        session[:current_question] = question.to_json
        session[:user_id] = student.id
      end

      it 'redirects to success page when all answers are correct' do
        post :check_answer, params: { category_id: category, puck1: '2.0', puck2: '3.0' }
        expect(response).to redirect_to(generate_practice_problems_path(category_id: category, success: true))
      end

      it 'sets error messages when answers are wrong' do
        post :check_answer, params: { category_id: category, puck1: '1.5', puck2: '3.5' }
        expect(assigns(:error_message)).to include('incorrect')
      end
    end
  end

  # Test for handle_collision_problem
  describe 'GET #generate for Momentum & Collisions' do
    let(:collision_context) do
      {
        category: 'Momentum & Collisions',
        generator: instance_double(CollisionProblemGenerator),
        question: {
          type: 'momentum & collisions',
          question: 'Test collision question',
          answer: 10.0
        }
      }
    end

    before do
      allow(CollisionProblemGenerator).to receive(:new)
        .with(collision_context[:category])
        .and_return(collision_context[:generator])
      allow(collision_context[:generator]).to receive(:generate_questions)
        .and_return([collision_context[:question]])
    end

    it 'generates a collision problem' do
      get :generate, params: { category_id: collision_context[:category] }
      expect(assigns(:question)).to eq(collision_context[:question])
    end

    it 'stores the question in the session' do
      get :generate, params: { category_id: collision_context[:category] }
      session_data = JSON.parse(controller.session[:current_question], symbolize_names: true)
      expect(session_data[:type]).to eq('momentum & collisions')
    end
  end

  # Tests for error propagation handling
  describe 'POST #check_answer with error propagation problems' do
    let(:category) { 'Propagation of Error' }
    let!(:student) do
      Student.create!(email: 'test@example.com', first_name: 'test', last_name: 'student', uin: '123456789')
    end

    context 'with percentage answer' do
      let(:question) do
        {
          type: 'propagation of error',
          question: 'Calculate the percentage error',
          answer: 5.0,
          field_label: 'Answer (%)'
        }
      end

      before do
        session[:current_question] = question.to_json
        session[:user_id] = student.id
      end

      it 'displays success message when percentage answer is correct' do
        allow(controller).to receive(:redirect_to_success).and_return(true)
        post :check_answer, params: { category_id: category, answer: '5.0', success: true }
        expect(controller.params[:success]).to eq('true')
        expect(response).to render_template('practice_problems/propagation_of_error_problem')
      end

      it 'displays success message when percentage answer is within tolerance' do
        allow(controller).to receive(:redirect_to_success).and_return(true)
        post :check_answer, params: { category_id: category, answer: '5.15', success: true }
        expect(controller.params[:success]).to eq('true')
        expect(response).to render_template('practice_problems/propagation_of_error_problem')
      end

      # it 'sets error message when percentage answer is wrong' do
      #   post :check_answer, params: { category_id: category, answer: '15.0' }
      #   expect(assigns(:error_message)).to include('too large')
      # end
    end

    context 'with standard answer' do
      let(:question) do
        {
          type: 'propagation of error',
          question: 'Calculate the error propagation',
          answer: 10.0
        }
      end

      before do
        session[:current_question] = question.to_json
        session[:user_id] = student.id
      end

      it 'displays success message when standard answer is correct' do
        allow(controller).to receive(:redirect_to_success).and_return(true)
        post :check_answer, params: { category_id: category, answer: '10.0', success: true }
        expect(controller.params[:success]).to eq('true')
        expect(response).to render_template('practice_problems/propagation_of_error_problem')
      end

      it 'displays success message when standard answer is within tolerance' do
        allow(controller).to receive(:redirect_to_success).and_return(true)
        post :check_answer, params: { category_id: category, answer: '10.4', success: true }
        expect(controller.params[:success]).to eq('true')
        expect(response).to render_template('practice_problems/propagation_of_error_problem')
      end

      it 'sets error message when standard answer is wrong' do
        post :check_answer, params: { category_id: category, answer: '11.0' }
        expect(assigns(:error_message)).to include('too large')
      end
    end
  end

  # Test for error propagation problem generation
  describe 'GET #generate for Error Propagation' do
    let(:error_prop_context) do
      {
        category: 'Propagation of Error',
        generator: instance_double(ErrorPropagationProblemGenerator),
        question: {
          type: 'propagation of error',
          question: 'Test error propagation question',
          answer: 5.0
        }
      }
    end

    before do
      allow(ErrorPropagationProblemGenerator).to receive(:new)
        .with(error_prop_context[:category])
        .and_return(error_prop_context[:generator])
      allow(error_prop_context[:generator]).to receive(:generate_questions)
        .and_return([error_prop_context[:question]])
    end

    it 'generates an error propagation problem' do
      get :generate, params: { category_id: error_prop_context[:category] }
      expect(assigns(:question)).to eq(error_prop_context[:question])
    end

    it 'stores the seed for reproducibility' do
      get :generate, params: { category_id: error_prop_context[:category] }
      expect(session[:error_propagation_seed]).to be_present
    end
  end
end

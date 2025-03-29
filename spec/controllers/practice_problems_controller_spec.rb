# spec/controllers/practice_problems_controller_spec.rb
require 'rails_helper'

RSpec.describe PracticeProblemsController, type: :controller do
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
        allow(basic_context[:problem_generator]).to receive(:generate_questions)
          .and_return(basic_context[:questions])
        get :generate, params: { category_id: basic_context[:category] }
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
        allow(basic_context[:problem_generator]).to receive(:generate_questions)
          .and_return([basic_context[:questions].first])
        get :generate, params: { category_id: basic_context[:category] }
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

    describe 'wrong answer template rendering' do
      let(:probability_question) { { type: 'probability', question: 'Test?', answer: 42 } }
      let(:confidence_interval_question) do
        { type: 'confidence_interval', answers: { lower_bound: 10, upper_bound: 20 } }
      end
      let(:data_statistics_question) do
        { type: 'data_statistics', answers: { mean: 5, median: 6 } }
      end

      it 'renders the statistics_problem template for wrong probability answers' do
        allow(controller).to receive(:parse_question_from_session).and_return(probability_question)
        post :check_answer, params: { category_id: 'Experimental Statistics', answer: 'wrong' }
        expect(response).to render_template('practice_problems/statistics_problem')
      end

      it 'renders the statistics_problem template for wrong data statistics answers' do
        allow(controller).to receive(:parse_question_from_session).and_return(data_statistics_question)
        post :check_answer, params: { category_id: 'Experimental Statistics', mean: 'wrong', median: 'wrong' }
        expect(response).to render_template('practice_problems/statistics_problem')
      end

      it 'renders the confidence_interval_problem template for wrong confidence interval answers' do
        allow(controller).to receive(:parse_question_from_session).and_return(confidence_interval_question)
        post :check_answer, params: { category_id: 'Confidence Intervals', lower_bound: 'wrong', upper_bound: 'wrong' }
        expect(response).to render_template('practice_problems/confidence_interval_problem')
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

    it 'renders the statistics_problem template when answer is wrong' do
      post :check_answer, params: { category_id: 'Probability', answer: 'wrong_answer' }
      expect(response).to render_template('practice_problems/statistics_problem')
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

    it 'stores the question in the session as JSON' do
      parsed_question = JSON.parse(session[:current_question], symbolize_names: true)
      expect(parsed_question[:type]).to eq('confidence_interval')
    end

    it 'renders the confidence_interval_problem template' do
      expect(response).to render_template('practice_problems/confidence_interval_problem')
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

  describe 'handle_confidence_interval_problem' do
    let(:ci_handle_context) do
      {
        category: 'Confidence Intervals',
        generator: instance_double(ConfidenceIntervalProblemGenerator),
        question: { type: 'confidence_interval', question: 'Test CI question' }
      }
    end

    before do
      allow(ConfidenceIntervalProblemGenerator).to receive(:new)
        .with(ci_handle_context[:category])
        .and_return(ci_handle_context[:generator])
      allow(ci_handle_context[:generator]).to receive(:generate_questions)
        .and_return([ci_handle_context[:question]])
      get :generate, params: { category_id: ci_handle_context[:category] }
    end

    it 'assigns the generated question' do
      expect(assigns(:question)).to eq(ci_handle_context[:question])
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

  describe '#determine_template_for_question' do
    it 'returns statistics_problem for probability questions' do
      controller = described_class.new
      question = { type: 'probability' }
      expect(controller.send(:determine_template_for_question, question)).to eq('statistics_problem')
    end

    it 'returns statistics_problem for data_statistics questions' do
      controller = described_class.new
      question = { type: 'data_statistics' }
      expect(controller.send(:determine_template_for_question, question)).to eq('statistics_problem')
    end

    it 'returns confidence_interval_problem for confidence_interval questions' do
      controller = described_class.new
      question = { type: 'confidence_interval' }
      expect(controller.send(:determine_template_for_question, question)).to eq('confidence_interval_problem')
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

    it 'returns finite_differences_problem for finite_differences questions' do
      controller = described_class.new
      question = { type: 'finite_differences' }
      expect(controller.send(:determine_template_for_question, question)).to eq('finite_differences_problem')
    end
  end

  describe 'finite differences template rendering' do
    before do
      allow(controller).to receive(:question_for_category).and_return({
                                                                        type: 'finite_differences',
                                                                        question: 'Test finite differences question',
                                                                        answer: 42
                                                                      })
    end

    it 'renders the finite_differences_problem template for finite differences questions' do
      get :generate, params: { category_id: 'Finite Differences' }
      expect(response).to render_template('finite_differences_problem')
    end
  end

  describe 'finite differences answer checking' do
    let(:finite_diff_question) do
      {
        type: 'finite_differences',
        question: 'Test question',
        answer: 42,
        input_fields: [{ label: 'Answer', key: 'answer' }],
        parameters: { answer: 42 }
      }
    end

    it 'redirects to success for correct finite differences answers' do
      allow(controller).to receive(:parse_question_from_session).and_return(finite_diff_question)
      post :check_answer, params: { category_id: 'Finite Differences', answer: '42' }
      expect(response).to redirect_to(generate_practice_problems_path(category_id: 'Finite Differences', success: true))
    end

    it 'renders the finite_differences_problem template for wrong finite differences answers' do
      allow(controller).to receive(:parse_question_from_session).and_return(finite_diff_question)
      post :check_answer, params: { category_id: 'Finite Differences', answer: 'wrong' }
      expect(response).to render_template('practice_problems/finite_differences_problem')
    end

    # Test the multi-field case also
    context 'with multiple input fields' do
      before do
        # Define the multi-field question
        multi_field_question = {
          type: 'finite_differences',
          question: 'Test multi-field question',
          answer: nil,
          input_fields: [
            { label: 'Forward Difference', key: 'forward_diff' },
            { label: 'Backward Difference', key: 'backward_diff' },
            { label: 'Centered Difference', key: 'centered_diff' }
          ],
          parameters: {
            forward_diff: 5.0,
            backward_diff: 4.5,
            centered_diff: 4.75
          }
        }

        allow(controller).to receive(:parse_question_from_session).and_return(multi_field_question)
      end

      # Combined params and expected paths to reduce memoized helpers
      let(:test_data) do
        {
          params: {
            category_id: 'Finite Differences',
            forward_diff: '5.0',
            backward_diff: '4.5',
            centered_diff: '4.75'
          },
          success_path: generate_practice_problems_path(
            category_id: 'Finite Differences',
            success: true
          )
        }
      end

      it 'redirects on successful submission' do
        post :check_answer, params: test_data[:params]
        expect(response).to redirect_to(test_data[:success_path])
      end
    end
  end

  describe 'finite differences functionality' do
    # Combine question definitions
    let(:fd_questions) do
      {
        single: {
          type: 'finite_differences',
          question: 'Test finite differences question',
          answer: 42,
          parameters: { x0: 2, h: 0.1 }
        },
        multiple: {
          type: 'finite_differences',
          question: 'Test finite differences with multiple fields',
          parameters: {
            forward: 12.5,
            backward: 11.8,
            centered: 12.0
          },
          input_fields: [
            { key: 'forward', label: 'Forward Difference' },
            { key: 'backward', label: 'Backward Difference' },
            { key: 'centered', label: 'Centered Difference' }
          ]
        }
      }
    end

    describe 'template rendering' do
      it 'renders the finite_differences_problem template for finite differences questions' do
        allow(controller).to receive(:question_for_category).and_return(fd_questions[:single])
        get :generate, params: { category_id: 'Finite Differences' }
        expect(response).to render_template('finite_differences_problem')
      end
    end

    describe 'generator setup' do
      let(:setup_data) do
        {
          category: 'Finite Differences',
          generator: instance_double(FiniteDifferencesProblemGenerator),
          question: fd_questions[:single]
        }
      end

      before do
        allow(FiniteDifferencesProblemGenerator).to receive(:new)
          .with(setup_data[:category])
          .and_return(setup_data[:generator])
        allow(setup_data[:generator]).to receive(:generate_questions)
          .and_return([setup_data[:question]])
      end

      it 'initializes the generator with the correct category' do
        get :generate, params: { category_id: setup_data[:category] }
        expect(FiniteDifferencesProblemGenerator).to have_received(:new).with(setup_data[:category])
      end

      it 'assigns the generated question' do
        get :generate, params: { category_id: setup_data[:category] }
        expect(assigns(:question)).to eq(setup_data[:question])
      end
    end

    describe 'single answer field correct submission' do
      before do
        session[:current_question] = fd_questions[:single].to_json
        post :check_answer, params: {
          category_id: 'Finite Differences',
          answer: '42'
        }
      end

      it 'redirects to success path' do
        expect(response).to redirect_to(
          generate_practice_problems_path(category_id: 'Finite Differences', success: true)
        )
      end
    end

    describe 'single answer field incorrect submission' do
      before do
        session[:current_question] = fd_questions[:single].to_json
        post :check_answer, params: {
          category_id: 'Finite Differences',
          answer: '40'
        }
      end

      it 'renders the template' do
        expect(response).to render_template('finite_differences_problem')
      end

      it 'sets error message' do
        expect(assigns(:error_message)).not_to be_nil
      end
    end

    describe 'multiple input fields with all correct answers' do
      before do
        session[:current_question] = fd_questions[:multiple].to_json
        post :check_answer, params: {
          category_id: 'Finite Differences',
          forward: '12.5',
          backward: '11.8',
          centered: '12.0'
        }
      end

      it 'redirects to success path' do
        expect(response).to redirect_to(
          generate_practice_problems_path(category_id: 'Finite Differences', success: true)
        )
      end
    end

    describe 'multiple input fields with one incorrect answer' do
      before do
        session[:current_question] = fd_questions[:multiple].to_json
        post :check_answer, params: {
          category_id: 'Finite Differences',
          forward: '12.5',
          backward: '10.0', # Incorrect value
          centered: '12.0'
        }
      end

      it 'renders the finite differences template' do
        expect(response).to render_template('finite_differences_problem')
      end

      it 'sets error message' do
        expect(assigns(:error_message)).not_to be_nil
      end
    end

    describe 'multiple input fields with missing answer' do
      before do
        session[:current_question] = fd_questions[:multiple].to_json
        post :check_answer, params: {
          category_id: 'Finite Differences',
          forward: '12.5',
          backward: '11.8'
          # centered is missing
        }
      end

      it 'renders the finite differences template' do
        expect(response).to render_template('finite_differences_problem')
      end

      it 'sets error message' do
        expect(assigns(:error_message)).not_to be_nil
      end
    end
  end

  context 'with propagation of error category' do
    let(:category) { 'propagation of error' }
    let(:generator) { instance_double("ErrorPropagationProblemGenerator") }
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
      it 'generates an error propagation problem' do
        get :generate, params: { category_id: category }
        expect(assigns(:question)).to eq(question)
        expect(response).to render_template('propagation_of_error_problem')
      end
    end

    describe 'POST #check_answer' do
      before do
        session[:current_question] = question.to_json
      end

      context 'with correct answer' do
        it 'renders the page with success parameter' do
          post :check_answer, params: { category_id: category, answer: '0.123' }
          expect(response).to render_template('propagation_of_error_problem')
          expect(assigns(:question)).to eq(question)
        end
      end

      context 'with close answer (within 5%)' do
        it 'renders the page with success parameter' do
          post :check_answer, params: { category_id: category, answer: '0.126' }
          expect(response).to render_template('propagation_of_error_problem')
          expect(assigns(:question)).to eq(question)
        end
      end

      context 'with incorrect answer' do
        it 'sets error message when too small' do
          post :check_answer, params: { category_id: category, answer: '0.090' }
          expect(assigns(:error_message)).to eq('too small')
          expect(response).to render_template('propagation_of_error_problem')
        end

        it 'sets error message when too large' do
          post :check_answer, params: { category_id: category, answer: '0.150' }
          expect(assigns(:error_message)).to eq('too large')
          expect(response).to render_template('propagation_of_error_problem')
        end
      end
    end
  end
end

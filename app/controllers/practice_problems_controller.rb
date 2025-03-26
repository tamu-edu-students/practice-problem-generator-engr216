class PracticeProblemsController < ApplicationController
  # List unique category names from the questions table.
  def index
    @categories = Question.distinct.pluck(:category)
    render :index
  end

  def generate
    @category = params[:category_id]
    @question = question_for_category

    # Store the current question in the session for validation later
    session[:current_question] = @question.to_json

    # Render the appropriate template based on question type
    template = determine_template_for_question(@question)
    render template
  end

  def question_for_category
    question_handlers = {
      'experimental statistics' => :handle_statistics_problem,
      'confidence intervals' => :handle_confidence_interval_problem,
      'engineering ethics' => :handle_engineering_ethics_problem,
      'finite differences' => :handle_finite_differences_problem
    }

    handler = question_handlers[@category.downcase]
    handler ? send(handler) : handle_default_category
  end

  def check_answer
    # Get the category string from params.
    @category = params[:category_id]
    @question = parse_question_from_session
    @error_message = nil

    handle_missing_question and return unless @question

    process_answer_for_question_type and return

    # If not redirected, re-render the form with error message.
    session[:current_question] = @question.to_json
    template = determine_template_for_question(@question)
    render template
  end

  private

  def handle_statistics_problem
    generator = StatisticsProblemGenerator.new(@category)
    all_questions = generator.generate_questions
    select_question_by_type(all_questions)
  end

  def select_question_by_type(all_questions)
    last_type = session[:last_problem_type]
    question_type = last_type == 'probability' ? 'data_statistics' : 'probability'

    question = all_questions.find { |q| q[:type] == question_type }
    session[:last_problem_type] = question_type
    question
  end

  def handle_confidence_interval_problem
    generator = ConfidenceIntervalProblemGenerator.new(@category)
    questions = generator.generate_questions
    questions.first
  end

  def handle_engineering_ethics_problem
    generator = EngineeringEthicsProblemGenerator.new(@category)
    questions = generator.generate_questions
    questions.first
  end

  def handle_finite_differences_problem
    problem_generator = FiniteDifferencesProblemGenerator.new(@category)
    problem_generator.generate_questions.first
  end

  def handle_default_category
    all_questions = ProblemGenerator.new(@category).generate_questions
    pick_question(all_questions)
  end

  def pick_question(all_questions)
    filtered_questions = if session[:last_question] && all_questions.size > 1
                           all_questions.reject { |q| q[:question] == session[:last_question] }
                         else
                           all_questions
                         end
    filtered_questions.sample
  end

  def parse_question_from_session
    session[:current_question] ? JSON.parse(session[:current_question], symbolize_names: true) : nil
  rescue JSON::ParserError
    nil
  end

  def handle_missing_question
    redirect_to generate_practice_problems_path(category_id: @category)
    true
  end

  def redirect_to_success
    redirect_to generate_practice_problems_path(category_id: @category, success: true)
    :redirected
  end

  def process_answer_for_question_type
    question_type_handlers = {
      'probability' => :handle_probability,
      'data_statistics' => :handle_data_statistics,
      'confidence_interval' => :handle_confidence_interval,
      'engineering_ethics' => :handle_engineering_ethics,
      'finite_differences' => :handle_finite_differences
    }

    handler = question_type_handlers[@question[:type]]
    handler ? send(handler) : handle_unknown_question_type
  end

  def handle_probability
    check_probability_answer == :redirected
  end

  def handle_data_statistics
    check_data_statistics_answers == :redirected
  end

  def handle_confidence_interval
    check_confidence_interval_answers == :redirected
  end

  def handle_engineering_ethics
    check_engineering_ethics_answer == :redirected
  end

  def handle_finite_differences
    check_finite_differences_answer == :redirected
  end

  def handle_unknown_question_type
    @error_message = "Unknown question type: #{@question[:type]}"
    false
  end

  def check_probability_answer
    user_answer = params[:answer].to_f
    correct_answer = @question[:answer].to_f

    if (user_answer - correct_answer).abs < 0.01
      redirect_to_success
    else
      @error_message = user_answer < correct_answer ? 'too small' : 'too large'
      nil
    end
  end

  def check_data_statistics_answers
    answers = @question[:answers]
    all_correct = true

    answers.each_key do |key|
      next unless answer_incorrect?(key, answers[key])

      set_error_message(key, params[key].to_f, answers[key])
      all_correct = false
      break
    end

    redirect_to_success if all_correct
  end

  def check_confidence_interval_answers
    answers = @question[:answers]
    initialize_debug_info

    # Handle blank inputs
    return handle_blank_inputs if blank_input_present?

    # Extract parameters and calculate expected bounds
    extract_and_log_problem_parameters if @question[:question].present?

    # Compare user answers with expected answers
    check_confidence_bounds(answers)

    # Store debug info and check for success
    session[:debug_info] = @debug_info
    redirect_to_success if @error_message.nil?
  end

  def initialize_debug_info
    @debug_info = "Debug Information:\n"
    @debug_info += "- Your inputs: Lower bound=#{params[:lower_bound].inspect}, " \
                   "Upper bound=#{params[:upper_bound].inspect}\n"
  end

  def blank_input_present?
    if params[:lower_bound].blank?
      @error_message = 'please provide a value for lower bound'
      return true
    elsif params[:upper_bound].blank?
      @error_message = 'please provide a value for upper bound'
      return true
    end
    false
  end

  def handle_blank_inputs
    # This just returns nil to exit the main method
    nil
  end

  def check_confidence_bounds(answers)
    @error_message = check_lower_bound(answers[:lower_bound])
    return if @error_message

    @error_message = check_upper_bound(answers[:upper_bound])
  end

  def check_lower_bound(expected_value)
    check_bound('lower_bound', expected_value)
  end

  def check_upper_bound(expected_value)
    check_bound('upper_bound', expected_value)
  end

  def check_bound(bound_key, expected_value)
    user_value = params[bound_key].to_f
    diff = (user_value - expected_value).abs.round(2)

    return nil if diff <= 0.01

    direction = user_value < expected_value ? 'too low' : 'too high'
    "your #{bound_key.to_s.tr('_', ' ')} is #{direction} (correct answer: #{expected_value})"
  end

  def extract_and_log_problem_parameters
    # First check if we have parameters directly from the question data
    if parameter_data_available?
      log_parameters_from_question_data
      calculate_bounds_from_parameters
    elsif question_matches_statistical_pattern?
      process_question_text
    end
  end

  def parameter_data_available?
    @question[:parameters] &&
      @question[:parameters][:sample_size] &&
      @question[:parameters][:sample_mean] &&
      @question[:parameters][:pop_std] &&
      @question[:parameters][:confidence_level]
  end

  def log_parameters_from_question_data
    params = @question[:parameters]
    @debug_info += "- Parameters from question data: sample_size=#{params[:sample_size]}, "
    @debug_info += "sample_mean=#{params[:sample_mean]}, pop_std=#{params[:pop_std]}, "
    @debug_info += "confidence=#{params[:confidence_level]}%\n"
  end

  def calculate_bounds_from_parameters
    params = @question[:parameters]
    z_value = get_z_value(params[:confidence_level])
    margin_error = z_value * (params[:pop_std] / Math.sqrt(params[:sample_size]))
    calc_lower = (params[:sample_mean] - margin_error).round(2)
    calc_upper = (params[:sample_mean] + margin_error).round(2)
    @debug_info += "- Recalculated bounds: Lower=#{calc_lower}, Upper=#{calc_upper}\n"
  end

  def question_matches_statistical_pattern?
    pattern = /water samples|batteries|cereal|patients|wait time|cars|produce|shipments|parts|phone calls|households/
    pattern.match?(@question[:question])
  end

  def process_question_text
    extracted_params = extract_parameters_from_text
    log_extracted_parameters(extracted_params)
    calculate_bounds_from_extracted(extracted_params)
  end

  def extract_parameters_from_text
    {
      sample_size: extract_sample_size,
      sample_mean: extract_sample_mean,
      pop_std: extract_standard_deviation,
      confidence_level: extract_confidence_level
    }
  end

  # Define constants at class level
  SAMPLE_SIZE_PATTERNS = [
    /(\d+)\s+water samples/,
    /(\d+)\s+randomly selected batteries/,
    /(\d+)\s+boxes/,
    /(\d+)\s+emergency room patients/,
    /(\d+)\s+cars/,
    /(\d+)\s+pieces of produce/,
    /(\d+)\s+shipments/,
    /(\d+)\s+parts/,
    /(\d+)\s+phone calls/,
    /(\d+)\s+households/
  ].freeze

  SAMPLE_MEAN_PATTERNS = [
    /mean\s+concentration\s+of\s+([\d.]+)/,
    /mean\s+lifetime\s+is\s+([\d.]+)/,
    /mean\s+fill\s+of\s+([\d.]+)/,
    /mean\s+wait time\s+of\s+([\d.]+)/,
    /average\s+of\s+([\d.]+)/,
    /mean\s+delivery time\s+is\s+([\d.]+)/,
    /mean\s+diameter\s+of\s+([\d.]+)/,
    /mean\s+call duration\s+of\s+([\d.]+)/,
    /mean\s+usage\s+of\s+([\d.]+)/
  ].freeze

  # Extract sample size using patterns defined as constants
  def extract_sample_size
    match_with_patterns(SAMPLE_SIZE_PATTERNS)
  end

  # Extract sample mean using patterns defined as constants
  def extract_sample_mean
    match_with_patterns(SAMPLE_MEAN_PATTERNS)
  end

  def extract_standard_deviation
    pattern = /(?:population )?standard deviation\s+(?:is|of)\s+([\d.]+)/
    @question[:question].match(pattern)&.[](1)&.to_f
  end

  def extract_confidence_level
    pattern = /(\d+)%\s+confidence/
    @question[:question].match(pattern)&.[](1)&.to_i
  end

  def match_with_patterns(patterns)
    patterns.each do |pattern|
      match = @question[:question].match(pattern)
      return match[1].to_f if match
    end
    nil
  end

  def log_extracted_parameters(params)
    @debug_info += "- Extracted parameters: sample_size=#{params[:sample_size]}, "
    @debug_info += "sample_mean=#{params[:sample_mean]}, pop_std=#{params[:pop_std]}, "
    @debug_info += "confidence=#{params[:confidence_level]}%\n"
  end

  def calculate_bounds_from_extracted(params)
    return unless all_parameters_present?(params)

    z_value = get_z_value(params[:confidence_level])
    margin_error = calculate_margin_of_error(params, z_value)

    calc_lower = (params[:sample_mean] - margin_error).round(2)
    calc_upper = (params[:sample_mean] + margin_error).round(2)

    log_calculated_bounds(calc_lower, calc_upper)
  end

  def all_parameters_present?(params)
    params[:sample_size] && params[:sample_mean] &&
      params[:pop_std] && params[:confidence_level]
  end

  def calculate_margin_of_error(params, z_value)
    z_value * (params[:pop_std] / Math.sqrt(params[:sample_size]))
  end

  def log_calculated_bounds(lower, upper)
    @debug_info += "- Recalculated bounds: Lower=#{lower}, Upper=#{upper}\n"
  end

  def set_error_message(key, user_value, expected_value)
    direction = user_value < expected_value ? 'low' : 'high'
    key_str = key.to_s.humanize.downcase
    @error_message = "your #{key_str} is too #{direction} (correct answer: #{expected_value})"
  end

  def answer_incorrect?(key, expected_value)
    return true if params[key].blank?

    user_value = params[key].to_f
    (user_value - expected_value).abs > 0.01
  end

  def get_z_value(confidence_level)
    z_values = {
      90 => 1.645,
      95 => 1.96,
      98 => 2.33,
      99 => 2.575
    }

    z_values.fetch(confidence_level, 1.96)
  end

  def check_engineering_ethics_answer
    user_answer = params[:ethics_answer] == 'true'
    correct_answer = @question[:answer]

    if user_answer == correct_answer
      redirect_to_success
    else
      @error_message = "That's incorrect. The correct answer is #{correct_answer ? 'True' : 'False'}."
      nil
    end
  end

  def check_finite_differences_answer
    if @question[:input_fields].present?
      handle_multiple_input_fields
    else
      handle_single_answer
    end
  end

  def handle_multiple_input_fields
    # Ensure parameters exist
    @question[:parameters] ||= {}

    check_individual_fields
  end

  def check_individual_fields
    all_correct = true

    @question[:input_fields].each do |field|
      result = check_input_field(field)
      unless result == :correct
        all_correct = false
        break
      end
    end

    redirect_to_success if all_correct
  end

  def check_input_field(field)
    key = field[:key].to_sym

    unless @question[:parameters].key?(key)
      @error_message = "Missing parameter definition for #{field[:label]}"
      return :error
    end

    validate_field_value(field, key)
  end

  def validate_field_value(field, key)
    expected_value = @question[:parameters][key].to_f
    user_value = params[field[:key]].to_f

    return :correct if (user_value - expected_value).abs <= 0.01

    direction = user_value < expected_value ? 'too low' : 'too high'
    @error_message = "your #{field[:label].downcase} is #{direction} (correct answer: #{expected_value})"
    :error
  end

  def handle_single_answer
    user_answer = params[:answer].to_f
    correct_answer = @question[:answer].to_f

    if (user_answer - correct_answer).abs < 0.01
      redirect_to_success
    else
      @error_message = user_answer < correct_answer ? 'too small' : 'too large'
      nil
    end
  end

  def determine_template_for_question(question)
    template_map = {
      'probability' => 'statistics_problem',
      'data_statistics' => 'statistics_problem',
      'confidence_interval' => 'confidence_interval_problem',
      'engineering_ethics' => 'engineering_ethics_problem',
      'finite_differences' => 'finite_differences_problem'
    }

    template_map[question[:type]] || 'generate' # fallback to the original template
  end
end

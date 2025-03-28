# rubocop:disable Metrics/ClassLength, Layout/LineLength
class PracticeProblemsController < ApplicationController
  # List unique category names from the questions table.
  def index
    @categories = Question.distinct.pluck(:category)
    render :index
  end

  def generate
    @category = params[:category_id]
    # Redirect to dedicated controllers if applicable.
    return redirect_to(generate_measurements_and_error_problems_path) if measurement_and_error_category?(@category)
    return redirect_to(generate_harmonic_motion_problems_path) if harmonic_motion_category?(@category)

    @question = question_for_category
    session[:current_question] = @question.to_json
    render determine_template_for_question(@question)
  end

  def check_answer
    @category = params[:category_id]
    return if special_category_redirect?

    @question = parse_question_from_session
    @error_message = nil
    return handle_missing_question unless @question

    process_answer_for_question_type and return

    session[:current_question] = @question.to_json
    render determine_template_for_question(@question)
  end

  private

  def special_category_redirect?
    if measurement_and_error_category?(@category)
      redirect_to(generate_measurements_and_error_problems_path) and return true
    elsif harmonic_motion_category?(@category)
      redirect_to(generate_harmonic_motion_problems_path) and return true
    end

    false
  end

  def measurement_and_error_category?(category)
    category.to_s.downcase.include?('measurement')
  end

  def harmonic_motion_category?(category)
    category.to_s.downcase.include?('harmonic')
  end

  def question_for_category
    handlers = {
      'experimental statistics' => :handle_statistics_problem,
      'confidence intervals' => :handle_confidence_interval_problem,
      'engineering ethics' => :handle_engineering_ethics_problem,
      'finite differences' => :handle_finite_differences_problem,
      'universal accounting equation' => :handle_universal_account_equations_problem
    }
    handler = handlers[@category.downcase]
    handler ? send(handler) : handle_default_category
  end

  def handle_statistics_problem
    generator = StatisticsProblemGenerator.new(@category)
    questions = generator.generate_questions
    select_question_by_type(questions)
  end

  def select_question_by_type(questions)
    last = session[:last_problem_type]
    type = last == 'probability' ? 'data_statistics' : 'probability'
    question = questions.find { |q| q[:type] == type }
    session[:last_problem_type] = type
    question
  end

  def handle_confidence_interval_problem
    generator = ConfidenceIntervalProblemGenerator.new(@category)
    generator.generate_questions.first
  end

  def handle_engineering_ethics_problem
    generator = EngineeringEthicsProblemGenerator.new(@category)
    generator.generate_questions.first
  end

  def handle_universal_account_equations_problem
    generator = UniversalAccountEquationsProblemGenerator.new(@category)
    generator.generate_questions.first
  end

  def handle_finite_differences_problem
    generator = FiniteDifferencesProblemGenerator.new(@category)
    generator.generate_questions.first
  end

  def handle_default_category
    questions = ProblemGenerator.new(@category).generate_questions
    pick_question(questions)
  end

  def pick_question(questions)
    filtered = if session[:last_question] && questions.size > 1
                 questions.reject { |q| q[:question] == session[:last_question] }
               else
                 questions
               end
    filtered.sample
  end

  def parse_question_from_session
    session[:current_question] ? JSON.parse(session[:current_question], symbolize_names: true) : nil
  rescue JSON::ParserError
    nil
  end

  def handle_missing_question
    redirect_to(generate_practice_problems_path(category_id: @category))
    true
  end

  def redirect_to_success
    redirect_to(generate_practice_problems_path(category_id: @category, success: true))
    :redirected
  end

  def process_answer_for_question_type
    handlers = {
      'probability' => :handle_probability,
      'data_statistics' => :handle_data_statistics,
      'confidence_interval' => :handle_confidence_interval,
      'engineering_ethics' => :handle_engineering_ethics,
      'finite_differences' => :handle_finite_differences,
      'universal_account_equations' => :handle_universal_account_equations
    }
    handler = handlers[@question[:type]]
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

  def handle_universal_account_equations
    check_universal_account_equations_answer == :redirected
  end

  def handle_unknown_question_type
    @error_message = "Unknown question type: #{@question[:type]}"
    false
  end

  def check_probability_answer
    user_ans = params[:answer].to_f
    correct = @question[:answer].to_f
    if (user_ans - correct).abs < 0.01
      redirect_to_success
    else
      @error_message = user_ans < correct ? 'too small' : 'too large'
      nil
    end
  end

  def check_data_statistics_answers
    answers = @question[:answers]
    all_correct = answers.each_key.all? do |key|
      next true if params[key].blank?

      user_val = params[key].to_f
      (user_val - answers[key]).abs <= 0.01
    end
    unless all_correct
      answers.each_key do |key|
        next unless answer_incorrect?(key, answers[key])

        set_error_message(key, params[key].to_f, answers[key])
        break
      end
    end
    redirect_to_success if all_correct
  end

  def check_confidence_interval_answers
    answers = @question[:answers]
    initialize_debug_info
    return handle_blank_inputs if blank_input_present?

    extract_and_log_problem_parameters if @question[:question].present?
    check_confidence_bounds(answers)
    session[:debug_info] = @debug_info
    redirect_to_success if @error_message.nil?
  end

  def initialize_debug_info
    @debug_info = "Debug Information:\n"
    @debug_info += "- Your inputs: Lower bound=#{params[:lower_bound].inspect}, Upper bound=#{params[:upper_bound].inspect}\n"
  end

  def blank_input_present?
    if params[:lower_bound].blank?
      @error_message = 'please provide a value for lower bound'
      true
    elsif params[:upper_bound].blank?
      @error_message = 'please provide a value for upper bound'
      true
    else
      false
    end
  end

  def handle_blank_inputs
    nil
  end

  def check_confidence_bounds(answers)
    @error_message = check_lower_bound(answers[:lower_bound])
    return if @error_message

    @error_message = check_upper_bound(answers[:upper_bound])
  end

  def check_lower_bound(expected)
    check_bound('lower_bound', expected)
  end

  def check_upper_bound(expected)
    check_bound('upper_bound', expected)
  end

  def check_bound(bound_key, expected)
    user_val = params[bound_key].to_f
    diff = (user_val - expected).abs.round(2)
    return nil if diff <= 0.01

    direction = user_val < expected ? 'too low' : 'too high'
    "your #{bound_key.to_s.tr('_', ' ')} is #{direction} (correct answer: #{expected})"
  end

  def extract_and_log_problem_parameters
    if parameter_data_available?
      log_parameters_from_question_data
      calculate_bounds_from_parameters
    elsif question_matches_statistical_pattern?
      process_question_text
    end
  end

  def parameter_data_available?
    params = @question[:parameters]
    params && params[:sample_size] && params[:sample_mean] && params[:pop_std] && params[:confidence_level]
  end

  def log_parameters_from_question_data
    pd = @question[:parameters]
    @debug_info += "- Parameters from question data: sample_size=#{pd[:sample_size]}, sample_mean=#{pd[:sample_mean]}, pop_std=#{pd[:pop_std]}, confidence=#{pd[:confidence_level]}%\n"
  end

  def calculate_bounds_from_parameters
    pd = @question[:parameters]
    z_value = get_z_value(pd[:confidence_level])
    margin_error = z_value * (pd[:pop_std] / Math.sqrt(pd[:sample_size]))
    calc_lower = (pd[:sample_mean] - margin_error).round(2)
    calc_upper = (pd[:sample_mean] + margin_error).round(2)
    @debug_info += "- Recalculated bounds: Lower=#{calc_lower}, Upper=#{calc_upper}\n"
  end

  def question_matches_statistical_pattern?
    pattern = /water samples|batteries|cereal|patients|wait time|cars|produce|shipments|parts|phone calls|households/
    pattern.match?(@question[:question])
  end

  def process_question_text
    extracted = extract_parameters_from_text
    log_extracted_parameters(extracted)
    calculate_bounds_from_extracted(extracted)
  end

  def extract_parameters_from_text
    {
      sample_size: extract_sample_size,
      sample_mean: extract_sample_mean,
      pop_std: extract_standard_deviation,
      confidence_level: extract_confidence_level
    }
  end

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

  def extract_sample_size
    match_with_patterns(SAMPLE_SIZE_PATTERNS)
  end

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

  def log_extracted_parameters(extracted)
    @debug_info += "- Extracted parameters: sample_size=#{extracted[:sample_size]}, sample_mean=#{extracted[:sample_mean]}, pop_std=#{extracted[:pop_std]}, confidence=#{extracted[:confidence_level]}%\n"
  end

  def calculate_bounds_from_extracted(extracted)
    return unless all_parameters_present?(extracted)

    z_value = get_z_value(extracted[:confidence_level])
    margin_error = calculate_margin_of_error(extracted, z_value)
    calc_lower = (extracted[:sample_mean] - margin_error).round(2)
    calc_upper = (extracted[:sample_mean] + margin_error).round(2)
    log_calculated_bounds(calc_lower, calc_upper)
  end

  def all_parameters_present?(extracted)
    extracted[:sample_size] && extracted[:sample_mean] && extracted[:pop_std] && extracted[:confidence_level]
  end

  def calculate_margin_of_error(extracted, z_value)
    z_value * (extracted[:pop_std] / Math.sqrt(extracted[:sample_size]))
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
    z_values = { 90 => 1.645, 95 => 1.96, 98 => 2.33, 99 => 2.575 }
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

  def check_universal_account_equations_answer
    user_answer = params[:answer].to_f
    correct_answer = @question[:answer]
    if (user_answer - correct_answer).abs <= 0.01
      redirect_to_success
    else
      direction = user_answer < correct_answer ? 'too low' : 'too high'
      @error_message = "That's incorrect. Your answer is #{direction} (correct answer: #{correct_answer})"
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
      'finite_differences' => 'finite_differences_problem',
      'universal_account_equations' => 'universal_account_equations_problem'
    }
    template_map[question[:type]] || 'generate'
  end
end
# rubocop:enable Metrics/ClassLength, Layout/LineLength

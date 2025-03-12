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

    render :generate
  end

  def question_for_category
    case @category.downcase
    when 'experimental statistics'
      handle_statistics_problem
    when 'confidence intervals'
      handle_confidence_interval_problem
    else
      handle_default_category
    end
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
    render :generate
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
    return handle_probability if @question[:type] == 'probability'
    return handle_data_statistics if @question[:type] == 'data_statistics'
    return handle_confidence_interval if @question[:type] == 'confidence_interval'

    handle_unknown_question_type
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

    # Build debug info for testing
    @debug_info = "Debug Information:\n"
    @debug_info += "- Your inputs: Lower bound=#{params[:lower_bound].inspect}, Upper bound=#{params[:upper_bound].inspect}\n"
    @debug_info += "- Expected answers: Lower=#{answers[:lower_bound]}, Upper=#{answers[:upper_bound]}\n"

    # Access parameters directly from question data
    if @question[:parameters]
      sample_size = @question[:parameters][:sample_size]
      sample_mean = @question[:parameters][:sample_mean]
      pop_std = @question[:parameters][:pop_std]
      confidence_level = @question[:parameters][:confidence_level]

      @debug_info += "- Parameters from question data: sample_size=#{sample_size}, "
      @debug_info += "sample_mean=#{sample_mean}, pop_std=#{pop_std}, "
      @debug_info += "confidence=#{confidence_level}%\n"

      if sample_size && sample_mean && pop_std && confidence_level
        z_value = get_z_value(confidence_level)
        margin_error = z_value * (pop_std / Math.sqrt(sample_size))
        calc_lower = (sample_mean - margin_error).round(2)
        calc_upper = (sample_mean + margin_error).round(2)
        @debug_info += "- Recalculated bounds: Lower=#{calc_lower}, Upper=#{calc_upper}\n"
      end
    elsif /water samples|batteries|cereal|patients|wait time|cars|produce|shipments|parts|phone calls|households/.match?(@question[:question])
      # Fallback for testing
      sample_size = @question[:question].match(/(\d+)\s+(?:water samples|randomly selected batteries|boxes|emergency room patients|cars|pieces of produce|shipments|parts|phone calls|households)/)&.[](1)&.to_i
      sample_mean = @question[:question].match(/mean\s+(?:concentration|lifetime|fill|wait time|of|is|delivery time|diameter|call duration|usage)\s+(?:of|is)\s+([\d.]+)/)&.[](1)&.to_f
      pop_std = @question[:question].match(/(?:population )?standard deviation\s+(?:is|of)\s+([\d.]+)/)&.[](1)&.to_f
      confidence_level = @question[:question].match(/(\d+)%\s+confidence/)&.[](1)&.to_i

      @debug_info += "- Extracted parameters: sample_size=#{sample_size}, "
      @debug_info += "sample_mean=#{sample_mean}, pop_std=#{pop_std}, "
      @debug_info += "confidence=#{confidence_level}%\n"

      if sample_size && sample_mean && pop_std && confidence_level
        z_value = get_z_value(confidence_level)
        margin_error = z_value * (pop_std / Math.sqrt(sample_size))
        calc_lower = (sample_mean - margin_error).round(2)
        calc_upper = (sample_mean + margin_error).round(2)
        @debug_info += "- Recalculated bounds: Lower=#{calc_lower}, Upper=#{calc_upper}\n"
      end
    end

    session[:debug_info] = @debug_info

    # First, handle blanks
    if params[:lower_bound].blank?
      @error_message = 'please provide a value for lower bound'
    elsif params[:upper_bound].blank?
      @error_message = 'please provide a value for upper bound'
    else
      # Round the differences to 2 decimal places to eliminate floating point issues
      lb_diff = (params[:lower_bound].to_f - answers[:lower_bound]).abs.round(2)
      ub_diff = (params[:upper_bound].to_f - answers[:upper_bound]).abs.round(2)

      # Fix line length issues by breaking into multiple lines
      if lb_diff > 0.01
        direction = params[:lower_bound].to_f < answers[:lower_bound] ? 'too low' : 'too high'
        @error_message = "your lower bound is #{direction} " \
                         "(correct answer: #{answers[:lower_bound]})"
      elsif ub_diff > 0.01
        direction = params[:upper_bound].to_f < answers[:upper_bound] ? 'too low' : 'too high'
        @error_message = "your upper bound is #{direction} " \
                         "(correct answer: #{answers[:upper_bound]})"
      end
    end

    # If no error was set, redirect to success.
    redirect_to_success if @error_message.nil?
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
    case confidence_level
    when 90 then 1.645
    when 95 then 1.96
    when 98 then 2.33
    when 99 then 2.575
    else 1.96
    end
  end
end

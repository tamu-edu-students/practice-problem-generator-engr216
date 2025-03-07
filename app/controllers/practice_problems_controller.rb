class PracticeProblemsController < ApplicationController
  # List unique category names from the questions table.
  def index
    @categories = Question.distinct.pluck(:category)
    render :index
  end

  def generate
    # Use the category string from the parameters instead of finding a Category object.
    @category = params[:category_id]

    # Use the specific generator for experimental statistics (if applicable)
    if @category.downcase == 'experimental statistics'
      handle_statistics_problem
    else
      all_questions = ProblemGenerator.new(@category).generate_questions
      @question = pick_question(all_questions)
    end

    # Store the current question in the session for validation later.
    session[:current_question] = @question.to_json

    render :generate
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
    # Generate questions for experimental statistics.
    generator = StatisticsProblemGenerator.new(@category)
    all_questions = generator.generate_questions

    last_type = session[:last_problem_type]
    if last_type == 'probability'
      @question = all_questions.find { |q| q[:type] == 'data_statistics' }
      session[:last_problem_type] = 'data_statistics'
    else
      @question = all_questions.find { |q| q[:type] == 'probability' }
      session[:last_problem_type] = 'probability'
    end
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
    result = case @question[:type]
             when 'probability'
               check_probability_answer
             when 'data_statistics'
               check_data_statistics_answers
             end

    result == :redirected
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

      set_error_message(key, params[key].to_f, answers[key].to_f)
      all_correct = false
      break
    end

    redirect_to_success if all_correct
  end

  def answer_incorrect?(key, correct_value)
    user_value = params[key].to_f
    (user_value - correct_value.to_f).abs >= 0.01
  end

  def set_error_message(key, user_value, correct_value)
    @error_message = "your #{key} is #{user_value < correct_value ? 'too small' : 'too large'}"
  end
end

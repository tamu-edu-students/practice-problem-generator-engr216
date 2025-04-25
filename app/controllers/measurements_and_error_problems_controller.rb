class MeasurementsAndErrorProblemsController < ApplicationController
  def view_answer
    @category = 'Measurement & Error'
    @question = parse_question_from_session

    if @question
      save_answer_to_database(false) # Mark as incorrect
      @show_answer = true
      @disable_check_answer = true
    else
      Rails.logger.error { 'No question found in session, redirecting to generate path' }
      redirect_to(generate_measurements_and_error_problems_path) and return
    end

    render 'practice_problems/measurements_error_problem'
  end

  # GET /measurements_and_error_problems/generate
  def generate
    @category = 'Measurement & Error'
    @question = generate_measurements_error_question

    # Store the current question in session for later validation
    session[:current_question] = @question.to_json
    session[:problem_start_time] = Time.current.to_s

    # Render the view (which is located in app/views/practice_problems/)
    render 'practice_problems/measurements_error_problem'
  end

  # POST /measurements_and_error_problems/check_answer
  def check_answer
    @category = 'Measurement & Error'
    @question = parse_question_from_session

    redirect_to generate_measurements_and_error_problems_path and return unless @question

    # Check the answer and set a feedback message
    @feedback_message = if handle_measurements_error
                          'Correct, your answer is right!'
                        else
                          'Incorrect, try again or press View Answer.'
                        end

    save_answer_to_database(handle_measurements_error) if handle_measurements_error

    # Disable the view answer button if the answer is correct
    @disable_view_answer = true if @feedback_message.include?('Correct')

    # Render the same view with the feedback displayed
    render 'practice_problems/measurements_error_problem'
  end

  private

  def generate_measurements_error_question
    generator = MeasurementsAndErrorProblemGenerator.new(@category)
    generator.generate_questions.first
  end

  def parse_question_from_session
    session[:current_question] ? JSON.parse(session[:current_question], symbolize_names: true) : nil
  rescue JSON::ParserError
    nil
  end

  def handle_measurements_error
    user_answer = params[:measurement_answer]
    correct_answer = @question[:answer]
    user_answer == correct_answer
  end

  def save_answer_to_database(is_correct)
    student = Student.find_by(id: session[:user_id])

    # Get calculated time spent
    time_spent = calculate_time_spent

    Rails.logger.debug { "Creating Answer record for category: #{@category}" }

    user_answer = params[:measurement_answer].to_s.strip
    user_answer = 'Answer Viewed By Student' if user_answer.empty?

    # Create and save the answer record
    answer = Answer.create(
      template_id: @question[:template_id] || 0,
      question_id: nil,
      category: @category,
      question_description: @question[:question],
      answer_choices: extract_answer_choices,
      answer: user_answer,
      correctness: is_correct,
      student_email: student.email,
      date_completed: Time.current.strftime('%Y-%m-%d %H:%M:%S'),
      time_spent: time_spent
    )
    Rails.logger.error { "Failed to save answer: #{answer.errors.full_messages.join(', ')}" } unless answer.persisted?
  end

  def calculate_time_spent
    return nil unless session[:problem_start_time]

    begin
      (Time.current - Time.zone.parse(session[:problem_start_time])).to_i.to_s
    rescue StandardError => e
      Rails.logger.debug { "Error calculating time spent: #{e.message}" }
      nil
    end
  end

  def extract_answer_choices
    return '[]' unless @question[:answer_choices]

    @question[:answer_choices].to_json
  rescue StandardError
    nil
  end
end

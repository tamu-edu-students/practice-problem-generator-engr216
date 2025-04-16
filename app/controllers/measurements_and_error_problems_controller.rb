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
    # Rails.logger.debug { "Saving answer to database: correct=#{is_correct}" }

    student = Student.find_by(id: session[:user_id])
    # if student
    #   Rails.logger.debug { "Student found: #{student.email}" }
    # else
    #   Rails.logger.debug { "No student found with ID: #{session[:user_id]}" }
    #   return # Don't save if no student is logged in
    # end

    # Calculate time spent on the problem
    time_spent = nil
    if session[:problem_start_time]
      begin
        time_spent = (Time.current - Time.zone.parse(session[:problem_start_time])).to_i.to_s
        # Rails.logger.debug { "Time spent on problem: #{time_spent} seconds" }
      rescue StandardError => e
        Rails.logger.debug { "Error calculating time spent: #{e.message}" }
      end
    else
      Rails.logger.debug { 'No problem start time available' }
    end

    # Get user's answer based on the question type
    # user_answer = params[:measurement_answer]
    # Rails.logger.debug { "Extracted user answer: #{user_answer}" }

    Rails.logger.debug { "Creating Answer record for category: #{@category}" }

    user_answer = params[:measurement_answer].to_s.strip
    user_answer = 'Answer Viewed By Student' if user_answer.empty?

    # Create and save the answer record
    answer = Answer.create(
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

    # if answer.save
    #   # Success
    # else
    #   Rails.logger.error { "Failed to save answer: #{answer.errors.full_messages.inspect}" }
    # end

    # Rails.logger.debug { "Answer record created: #{answer.persisted? ? 'success' : 'failed'}" }
  end

  def extract_answer_choices
    return '[]' unless @question[:answer_choices]

    @question[:answer_choices].to_json
  rescue StandardError
    nil
  end
end

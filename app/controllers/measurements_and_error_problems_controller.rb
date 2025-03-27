class MeasurementsAndErrorProblemsController < ApplicationController
  # GET /measurements_and_error_problems/generate
  def generate
    @category = 'Measurement & Error'
    @question = generate_measurements_error_question

    # Store the current question in session for later validation
    session[:current_question] = @question.to_json

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
                          "Incorrect, the correct answer is #{@question[:answer]}."
                        end

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
end

class HarmonicMotionProblemsController < ApplicationController
  def view_answer
    @category = 'Harmonic Motion'
    @question = JSON.parse(session[:current_question], symbolize_names: true)

    if @question
      save_answer_to_database(false, 'Answer Viewed By Student') # Mark as incorrect
      @show_answer = true
      @disable_check_answer = true
    else
      Rails.logger.error { 'No question found in session, redirecting to generate path' }
      redirect_to(generate_harmonic_motion_problems_path) and return
    end

    render 'practice_problems/harmonic_motion_problem'
  end

  def generate
    @category = 'Harmonic Motion'
    @question = HarmonicMotionProblemGenerator.new(@category).generate_questions.first
    session[:current_question] = @question.to_json
    render 'practice_problems/harmonic_motion_problem'
    session[:problem_start_time] = Time.current.to_s
  end

  def check_answer
    @category = 'Harmonic Motion'
    @question = JSON.parse(session[:current_question], symbolize_names: true)
    tolerance = 0.05

    @feedback_message = evaluate_answer(@question[:answer], tolerance)
    render 'practice_problems/harmonic_motion_problem'
  end

  private

  def evaluate_answer(correct_answer, tolerance)
    if correct_answer.is_a?(Array)
      check_multi_part_answer(correct_answer, tolerance)
    else
      check_single_answer(correct_answer, tolerance)
    end
  end

  def check_multi_part_answer(correct_answers, tolerance)
    submitted_answers = []
    all_correct = correct_answers.each_with_index.all? do |correct_ans, i|
      submitted_ans = params["shm_answer_#{i + 1}"].to_s.strip
      submitted_answers << submitted_ans
      if numeric?(submitted_ans) && numeric?(correct_ans)
        (submitted_ans.to_f - correct_ans.to_f).abs <= tolerance
      else
        submitted_ans == correct_ans.to_s.strip
      end
    rescue ArgumentError, TypeError
      false
    end
    submitted_answers.join(', ')

    if all_correct
      save_answer_to_database(true, correct_answers.join(', '))
      "Correct, the answer #{correct_answers.join(', ')} is right!"
    else
      # save_answer_to_database(false, submitted_ans_str)
      'Incorrect, try again or press View Answer.'
    end
  end

  def check_single_answer(correct_ans, tolerance)
    submitted_ans = params[:shm_answer].to_s.strip
    if numeric?(submitted_ans) && numeric?(correct_ans)
      if (submitted_ans.to_f - correct_ans.to_f).abs <= tolerance
        save_answer_to_database(true, submitted_ans)
        "Correct, the answer #{correct_ans} is right!"
      else
        # save_answer_to_database(false, submitted_ans)
        'Incorrect, try again or press View Answer.'
      end
    elsif submitted_ans == correct_ans.to_s.strip
      save_answer_to_database(true, submitted_ans)
      "Correct, the answer #{correct_ans} is right!"
    else
      # save_answer_to_database(false, submitted_ans)
      'Incorrect, try again or press View Answer.'
    end
  end

  def numeric?(str)
    Float(str)
    true
  rescue ArgumentError, TypeError
    false
  end

  def save_answer_to_database(is_correct, answer)
    # Rails.logger.debug { "Saving answer to database: correct=#{is_correct}" }

    student = Student.find_by(id: session[:user_id])

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
    user_answer = answer
    # Rails.logger.debug { "Extracted user answer: #{user_answer}" }

    Rails.logger.debug { "Creating Answer record for category: #{@category}" }

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
  end

  def extract_answer_choices
    return '[]' unless @question[:answer_choices]

    @question[:answer_choices].to_json
  rescue StandardError
    nil
  end
end

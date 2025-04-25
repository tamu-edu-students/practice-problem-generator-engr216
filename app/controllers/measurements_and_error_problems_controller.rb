class MeasurementsAndErrorProblemsController < ApplicationController
  # rubocop:disable Metrics/AbcSize

  def view_answer
    @category = 'Measurement & Error'
    @question = parse_question_from_session

    if @question
      save_answer_to_database(false, 'Answer Viewed By Student') # Mark as incorrect
      @show_answer = true
      @disable_check_answer = true
    else
      Rails.logger.error { 'No question found in session, redirecting to generate path' }
      redirect_to(generate_measurements_and_error_problems_path) and return
    end

    render 'practice_problems/measurements_error_problem'
  end

  def generate
    @category = 'Measurement & Error'
    tries = 0

    loop do
      @question = generate_measurements_error_question
      tries += 1
      break unless (@question[:input_fields].blank? || @question[:input_fields].any?(&:nil?)) && tries < 5
    end

    Array(@question[:input_fields]).each do |field|
      next unless field[:type] == 'radio' && field[:options].is_a?(Array)

      original_options = field[:options].dup
      correct_label = @question[:answer]

      label_map = { 'A' => 0, 'B' => 1, 'C' => 2, 'D' => 3 }

      if correct_label.match?(/^[A-D]$/) && label_map[correct_label] && original_options[label_map[correct_label]]
        actual_value = original_options[label_map[correct_label]][:value]
        @question[:answer] = actual_value
      end

      field[:options] = field[:options].shuffle
    end

    session[:current_question] = @question.to_json
    session[:problem_start_time] = Time.current.to_s
    render 'practice_problems/measurements_error_problem'
  end

  def check_answer
    @category = 'Measurement & Error'
    @question = parse_question_from_session

    redirect_to generate_measurements_and_error_problems_path and return unless @question

    tolerance = 0.05
    correct_ans = @question[:answer]
    submitted_ans = params[:measurement_answer].to_s.strip

    is_correct = if numeric?(submitted_ans) && numeric?(correct_ans)
                   (submitted_ans.to_f - correct_ans.to_f).abs <= tolerance
                 else
                   submitted_ans == correct_ans.to_s.strip
                 end

    save_answer_to_database(is_correct, submitted_ans)

    @feedback_message = if is_correct
                          if radio_question?
                            "Correct, the answer #{submitted_letter(correct_ans)} is right!"
                          else
                            'Correct, your answer is right!'
                          end
                        else
                          standard_incorrect_message.to_s
                        end

    @disable_view_answer = true if @feedback_message.include?('Correct')

    render 'practice_problems/measurements_error_problem'
  end

  # rubocop:enable Metrics/AbcSize

  private

  def standard_incorrect_message
    'Incorrect, try again or press View Answer.'
  end

  def radio_question?
    @question[:input_fields]&.any? { |f| f[:type] == 'radio' }
  end

  def correct_letter(correct_ans)
    field = @question[:input_fields].find { |f| f[:type] == 'radio' }
    correct_index = field[:options]&.index { |opt| opt[:value].to_s.strip == correct_ans.to_s.strip }
    correct_index ? ('A'.ord + correct_index).chr : '?'
  end

  def submitted_letter(submitted_ans)
    field = @question[:input_fields].find { |f| f[:type] == 'radio' }
    submitted_index = field[:options]&.index { |opt| opt[:value].to_s.strip == submitted_ans.to_s.strip }
    submitted_index ? ('A'.ord + submitted_index).chr : '?'
  end

  def generate_measurements_error_question
    generator = MeasurementsAndErrorProblemGenerator.new(@category)
    generator.generate_questions.first
  end

  def parse_question_from_session
    session[:current_question] ? JSON.parse(session[:current_question], symbolize_names: true) : nil
  rescue JSON::ParserError
    nil
  end

  def numeric?(str)
    Float(str)
    true
  rescue ArgumentError, TypeError
    false
  end

  def save_answer_to_database(is_correct, submitted_value)
    student = Student.find_by(id: session[:user_id])
    time_spent = calculate_time_spent

    final_value = submitted_value
    if radio_question?
      field = @question[:input_fields].find { |f| f[:type] == 'radio' }
      index = field[:options]&.index { |opt| opt[:value] == submitted_value }
      final_value = index ? ('A'.ord + index).chr : '?'
    end

    Answer.create!(
      template_id: @question[:template_id] || 0,
      question_id: nil,
      category: @category,
      question_description: @question[:question],
      answer_choices: extract_answer_choices,
      answer: final_value,
      correctness: is_correct,
      student_email: student&.email,
      date_completed: Time.current.strftime('%Y-%m-%d %H:%M:%S'),
      time_spent: time_spent
    )
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

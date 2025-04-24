class MeasurementsAndErrorProblemsController < ApplicationController
  # rubocop:disable Metrics/AbcSize
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
      correct_label = @question[:answer] # e.g., "A"

      label_map = {
        'A' => 0,
        'B' => 1,
        'C' => 2,
        'D' => 3
      }

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

  # rubocop:enable Metrics/AbcSize
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/PerceivedComplexity
  def check_answer
    @category = 'Measurement & Error'
    @question = parse_question_from_session

    redirect_to generate_measurements_and_error_problems_path and return unless @question

    tolerance = 0.05
    correct_ans = @question[:answer]
    submitted_ans = params[:measurement_answer].to_s.strip

    correct_letter = '?'
    submitted_letter = '?'

    if @question[:input_fields]&.any? { |f| f[:type] == 'radio' }
      field = @question[:input_fields].find { |f| f[:type] == 'radio' }

      correct_index = field[:options]&.index { |opt| opt[:value].to_s.strip == correct_ans.to_s.strip }
      submitted_index = field[:options]&.index { |opt| opt[:value].to_s.strip == submitted_ans }

      correct_letter = correct_index ? ('A'.ord + correct_index).chr : '?'
      submitted_letter = submitted_index ? ('A'.ord + submitted_index).chr : '?'
    end

    is_correct = if numeric?(submitted_ans) && numeric?(correct_ans)
                   (submitted_ans.to_f - correct_ans.to_f).abs <= tolerance
                 else
                   submitted_ans == correct_ans.to_s.strip
                 end

    save_answer_to_database(is_correct, submitted_ans)

    @feedback_message = if is_correct
                          "Correct, the answer #{submitted_letter} is right!"
                        else
                          "Incorrect, the correct answer is #{correct_letter}."
                        end

    render 'practice_problems/measurements_error_problem'
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/PerceivedComplexity

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

  def numeric?(str)
    Float(str)
    true
  rescue ArgumentError, TypeError
    false
  end

  # rubocop:disable Metrics/AbcSize
  def save_answer_to_database(is_correct, submitted_value)
    student = Student.find_by(id: session[:user_id])
    time_spent = nil

    if session[:problem_start_time]
      begin
        time_spent = (Time.current - Time.zone.parse(session[:problem_start_time])).to_i.to_s
      rescue StandardError => e
        Rails.logger.debug { "Error calculating time spent: #{e.message}" }
      end
    end
    final_value = submitted_value

    if @question[:input_fields]&.any? { |f| f[:type] == 'radio' }
      field = @question[:input_fields].find { |f| f[:type] == 'radio' }
      index = field[:options]&.index { |opt| opt[:value] == submitted_value }
      letter = index ? ('A'.ord + index).chr : '?'
      final_value = letter
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

  # rubocop:enable Metrics/AbcSize
  def extract_answer_choices
    return '[]' unless @question[:answer_choices]

    @question[:answer_choices].to_json
  rescue StandardError
    nil
  end
end

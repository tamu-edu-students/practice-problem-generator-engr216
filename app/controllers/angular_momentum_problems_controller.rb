class AngularMomentumProblemsController < ApplicationController
  def view_answer
    @category = 'Angular Momentum'
    @question = session[:current_question] ? JSON.parse(session[:current_question], symbolize_names: true) : nil

    if @question
      save_answer_to_database(false, 'Answer Viewed By Student') # Mark as incorrect
      @show_answer = true
      @disable_check_answer = true
    else
      Rails.logger.error { 'No question found in session, redirecting to generate path' }
      redirect_to(generate_angular_momentum_problems_path) and return
    end

    render 'practice_problems/angular_momentum_problem'
  end

  # rubocop:disable Metrics/AbcSize
  def generate
    @category = 'Angular Momentum'
    tries = 0

    loop do
      @question = AngularMomentumProblemGenerator.new(@category).generate_questions.first
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
    render 'practice_problems/angular_momentum_problem'
  end
  # rubocop:enable Metrics/AbcSize

  def check_answer
    @category = 'Angular Momentum'
    @question = JSON.parse(session[:current_question], symbolize_names: true)
    tolerance = 0.05

    @feedback_message = evaluate_answer(@question[:answer], tolerance)

    @disable_view_answer = true if @feedback_message.include?('Correct')

    render 'practice_problems/angular_momentum_problem'
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
      submitted_ans = params["am_answer_#{i + 1}"].to_s.strip
      submitted_answers << submitted_ans
      if numeric?(submitted_ans) && numeric?(correct_ans)
        (submitted_ans.to_f - correct_ans.to_f).abs <= tolerance
      else
        submitted_ans == correct_ans.to_s.strip
      end
    rescue ArgumentError, TypeError
      false
    end

    if all_correct
      save_answer_to_database(true, correct_answers.join(', '))
      "Correct, the answer #{correct_answers.join(', ')} is right!"
    else
      'Incorrect, try again or press View Answer.'
    end
  end

  # rubocop:disable Metrics/AbcSize
  def check_single_answer(correct_ans, tolerance)
    submitted_ans = params[:am_answer].to_s.strip

    if @question[:input_fields]&.any? { |f| f[:type] == 'radio' }
      field = @question[:input_fields].find { |f| f[:type] == 'radio' }

      correct_index = field[:options]&.index { |opt| opt[:value].to_s.strip == correct_ans.to_s.strip }
      submitted_index = field[:options]&.index { |opt| opt[:value].to_s.strip == submitted_ans }

      correct_index ? ('A'.ord + correct_index).chr : '?'
      submitted_letter = submitted_index ? ('A'.ord + submitted_index).chr : '?'

      is_correct = submitted_index == correct_index

      save_answer_to_database(is_correct, submitted_ans)

      return "Correct, the answer #{submitted_letter} is right!" if is_correct

    else
      is_correct = if numeric?(submitted_ans) && numeric?(correct_ans)
                     (submitted_ans.to_f - correct_ans.to_f).abs <= tolerance
                   else
                     submitted_ans == correct_ans.to_s.strip
                   end

      save_answer_to_database(is_correct, submitted_ans)

      return "Correct, the answer #{correct_ans} is right!" if is_correct

    end
    'Incorrect, try again or press View Answer.'
  end

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

  def numeric?(str)
    Float(str)
    true
  rescue ArgumentError, TypeError
    false
  end
end

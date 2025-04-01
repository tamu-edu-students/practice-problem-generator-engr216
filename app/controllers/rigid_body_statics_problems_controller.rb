class RigidBodyStaticsProblemsController < ApplicationController
  def generate
    @category = 'Rigid Body Statics'
    @question = RigidBodyStaticsProblemGenerator.new(@category).generate_questions.first
    session[:current_question] = @question.to_json
    render 'practice_problems/rigid_body_statics_problem'
  end

  def check_answer
    @category = 'Rigid Body Statics'
    @question = JSON.parse(session[:current_question], symbolize_names: true)
    tolerance = 0.05

    @feedback_message = evaluate_answer(@question[:answer], tolerance)
    render 'practice_problems/rigid_body_statics_problem'
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
    all_correct = correct_answers.each_with_index.all? do |correct_ans, i|
      submitted_ans = params["rbs_answer_#{i + 1}"].to_s.strip
      if numeric?(submitted_ans) && numeric?(correct_ans)
        (submitted_ans.to_f - correct_ans.to_f).abs <= tolerance
      else
        submitted_ans == correct_ans.to_s.strip
      end
    rescue ArgumentError, TypeError
      false
    end

    if all_correct
      "Correct, the answer #{correct_answers.join(', ')} is right!"
    else
      "Incorrect, the correct answer is #{correct_answers.join(', ')}."
    end
  end

  def check_single_answer(correct_ans, tolerance)
    submitted_ans = params[:rbs_answer].to_s.strip
    if numeric?(submitted_ans) && numeric?(correct_ans)
      if (submitted_ans.to_f - correct_ans.to_f).abs <= tolerance
        "Correct, the answer #{correct_ans} is right!"
      else
        "Incorrect, the correct answer is #{correct_ans}."
      end
    elsif submitted_ans == correct_ans.to_s.strip
      "Correct, the answer #{correct_ans} is right!"
    else
      "Incorrect, the correct answer is #{correct_ans}."
    end
  end

  def numeric?(str)
    Float(str)
    true
  rescue ArgumentError, TypeError
    false
  end
end

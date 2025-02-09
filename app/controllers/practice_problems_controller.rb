class PracticeProblemsController < ApplicationController
  def index
    @categories = Category.all
    render :index
  end

  def generate
    @category = Category.find(params[:category_id])
    all_questions = ProblemGenerator.new(@category).generate_questions

    # If there is a stored problem and there’s more than one option, filter it out.
    filtered_questions = if session[:last_question] && all_questions.size > 1
                           all_questions.reject { |q| q[:question] == session[:last_question] }
                         else
                           all_questions
                         end

    @question = filtered_questions.sample

    # Store the current question so that next time it can be filtered out.
    session[:last_question] = @question[:question]
    render :generate
  end
end

class PracticeProblemsController < ApplicationController
  def index
    @categories = Category.all
    render :index
  end

  def generate
    @category = Category.find(params[:category_id])
    all_questions = ProblemGenerator.new(@category).generate_questions
    @question = pick_question(all_questions)
    session[:last_question] = @question[:question]
    render :generate
  end

  private

  def pick_question(all_questions)
    filtered_questions = if session[:last_question] && all_questions.size > 1
                           all_questions.reject { |q| q[:question] == session[:last_question] }
                         else
                           all_questions
                         end
    filtered_questions.sample
  end
end

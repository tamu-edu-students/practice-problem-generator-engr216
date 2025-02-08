class PracticeProblemsController < ApplicationController
  def index
    @categories = Category.all
    render :index
  end

  def generate
    @category = Category.find(params[:category_id])
    questions = ProblemGenerator.new(@category).generate_questions
    @question = questions.sample  # Pick one random question
    render :generate
  end
  
end

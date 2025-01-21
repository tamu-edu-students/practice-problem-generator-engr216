class PracticeProblemsController < ApplicationController
  def index
    @categories = Category.all
  end

  def generate
    @category = Category.find(params[:category_id])
    # Dummy data for multiple-choice questions
    @questions = [
      { question: "What is Newton's second law?", choices: ['F=ma', 'E=mc^2', 'P=IV', 'V=IR'], answer: 'F=ma' },
      { question: 'What is the unit of force?', choices: %w[Newton Joule Watt Ohm], answer: 'Newton' }
    ]
  end
end

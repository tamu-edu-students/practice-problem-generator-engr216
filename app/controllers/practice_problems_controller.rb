class PracticeProblemsController < ApplicationController
  def index
    @physics_units = [
      "Measurement & Error",
      "Propagation of Error",
      "Finite Differences",
      "Experimental Statistics",
      "Confidence Intervals",
      "Universal Accounting Equation",
      "Particle Statics",
      "Momentum & Collisions",
      "Rigid Body Statics",
      "Angular Momentum",
      "Harmonic Motion",
      "Engineering Ethics",
      "Art in Engineering"
    ]
  end

  # def generate
  #   @category = Category.find(params[:category_id])
  #   # Dummy data for multiple-choice questions
  #   @questions = [
  #     { question: "What is Newton's second law?", choices: ['F=ma', 'E=mc^2', 'P=IV', 'V=IR'], answer: 'F=ma' },
  #     { question: 'What is the unit of force?', choices: %w[Newton Joule Watt Ohm], answer: 'Newton' }
  #   ]
  # end
end

# app/services/problem_generator.rb
class ProblemGenerator
  QUESTIONS = [
    {
      question: "What is Newton's second law?",
      choices: ['F = ma', 'E = mc^2', 'P = IV', 'V = IR'],
      answer: 'F = ma'
    },
    {
      question: 'What is the unit of force?',
      choices: %w[Newton Joule Watt Ohm],
      answer: 'Newton'
    },
    {
      question: 'What is the acceleration due to gravity on Earth?',
      choices: ['9.8 m/s²', '9.8 km/s²', '8.9 m/s²', '9.2 m/s²'],
      answer: '9.8 m/s²'
    }
  ].freeze

  def initialize(category)
    @category = category
  end

  def generate_questions
    QUESTIONS
  end
end

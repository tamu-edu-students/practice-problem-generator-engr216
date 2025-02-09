# app/services/problem_generator.rb
class ProblemGenerator
  def initialize(category)
    @category = category
  end

  def generate_questions
    [
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
      },
      {
        question: 'Which of the following is a vector quantity?',
        choices: %w[Speed Distance Mass Velocity],
        answer: 'Velocity'
      },
      {
        question: 'What is the formula for gravitational force?',
        choices: ['F = G * (m1*m2)/r²', 'F = ma', 'F = mgh', 'F = kq1q2/r²'],
        answer: 'F = G * (m1*m2)/r²'
      },
      {
        question: 'What is the unit of electrical resistance?',
        choices: %w[Ohm Watt Volt Ampere],
        answer: 'Ohm'
      },
      {
        question: 'Which law explains why objects resist changes in their state of motion?',
        choices: ['Newton\'s First Law', 'Newton\'s Second Law', 'Newton\'s Third Law',
                  'Law of Conservation of Energy'],
        answer: 'Newton\'s First Law'
      },
      {
        question: 'What is the relationship between mass and weight on Earth?',
        choices: ['Weight = mass x 9.8 m/s²', 'Mass = weight / 9.8 m/s²', 'Both A and B', 'Neither A nor B'],
        answer: 'Both A and B'
      }
    ]
  end
end

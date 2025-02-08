class ProblemGenerator
    def initialize(category)
      @category = category
    end
  
    def generate_questions
      # Replace this with your actual problem generation logic.
      # For now, we return dummy data.
      [
        { question: "What is Newton's second law?", choices: ['F=ma', 'E=mc^2', 'P=IV', 'V=IR'], answer: 'F=ma' },
        { question: "What is the unit of force?", choices: ['Newton', 'Joule', 'Watt', 'Ohm'], answer: 'Newton' }
      ]
    end
  end
  
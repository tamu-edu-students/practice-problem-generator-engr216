class EngineeringEthicsProblemGenerator
  attr_reader :category

  def initialize(category)
    @category = category
  end

  def generate_questions
    [generate_ethics_problem]
  end

  private

  def generate_ethics_problem
    # Select a random question from our predefined set
    question_data = ethics_questions.sample

    {
      type: 'engineering_ethics',
      question: question_data[:question],
      answer: question_data[:answer],
      input_fields: [
        {
          label: 'Your Answer',
          key: 'ethics_answer',
          type: 'radio',
          options: [
            { value: 'true', label: 'True' },
            { value: 'false', label: 'False' }
          ]
        }
      ]
    }
  end

  def ethics_questions
    [
      {
        question: '"Accountability" is imposed externally on an individual by some authority.',
        answer: true
      },
      {
        question: 'An engineer believes that a condition exists and accepts information that supports the belief but rejects disproving information. This is an example of overconfidence bias.',
        answer: false
      },
      {
        question: 'Engineers shall at all times strive to serve their employer.',
        answer: false
      },
      {
        question: 'Bad news, criticism, questions, and information outside of expectations are regarded as negatives by the organization. This is an example of suppression of open communication.',
        answer: true
      },
      {
        question: 'An engineer has a duty to report any known safety violations to the proper authorities, even if doing so may harm the employer\'s reputation.',
        answer: true
      },
      {
        question: 'It is ethically acceptable for an engineer to accept a large gift from a supplier in exchange for awarding them a contract.',
        answer: false
      },
      {
        question: 'When faced with a conflict of interest, an engineer should disclose it to all affected parties.',
        answer: true
      },
      {
        question: 'Engineers can ignore legal requirements if they believe they have found a better technical solution.',
        answer: false
      },
      {
        question: 'Professional codes of ethics require engineers to prioritize public safety, health, and welfare above all else.',
        answer: true
      },
      {
        question: 'Whistleblowing is never justified if it violates the engineer\'s contractual obligations to an employer.',
        answer: false
      }
    ]
  end
end

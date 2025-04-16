# Extract questions into a separate module to reduce class length
module EngineeringEthicsQuestions
  def self.all_questions
    accountability + bias + professional_ethics + safety + conflict
  end

  def self.accountability
    [
      {
        question: '"Accountability" is imposed externally on an individual by some authority.',
        answer: true,
        template_id: 1
      }
    ]
  end

  def self.bias
    confirmation_bias + communication_suppression
  end

  def self.confirmation_bias
    [
      {
        question: 'An engineer believes that a condition exists and accepts information that supports ' \
                  'the belief but rejects disproving information. This is an example of overconfidence bias.',
        answer: false,
        template_id: 2
      }
    ]
  end

  def self.communication_suppression
    [
      {
        question: 'Bad news, criticism, questions, and information outside of expectations are regarded as ' \
                  'negatives by the organization. This is an example of suppression of open communication.',
        answer: true,
        template_id: 3
      }
    ]
  end

  def self.professional_ethics
    professional_duties + gift_policy + code_of_ethics + whistleblowing
  end

  def self.professional_duties
    [
      {
        question: 'Engineers shall at all times strive to serve their employer.',
        answer: false,
        template_id: 4
      }
    ]
  end

  def self.gift_policy
    [
      {
        question: 'It is ethically acceptable for an engineer to accept a large gift from a supplier ' \
                  'in exchange for awarding them a contract.',
        answer: false,
        template_id: 5
      }
    ]
  end

  def self.code_of_ethics
    [
      {
        question: 'Professional codes of ethics require engineers to prioritize public safety, health, ' \
                  'and welfare above all else.',
        answer: true,
        template_id: 6
      }
    ]
  end

  def self.whistleblowing
    [
      {
        question: 'Whistleblowing is never justified if it violates the engineer\'s contractual ' \
                  'obligations to an employer.',
        answer: false,
        template_id: 7
      }
    ]
  end

  def self.safety
    safety_reporting + legal_requirements
  end

  def self.safety_reporting
    [
      {
        question: 'An engineer has a duty to report any known safety violations to the proper authorities, ' \
                  'even if doing so may harm the employer\'s reputation.',
        answer: true,
        template_id: 8
      }
    ]
  end

  def self.legal_requirements
    [
      {
        question: 'Engineers can ignore legal requirements if they believe they have found a better ' \
                  'technical solution.',
        answer: false,
        template_id: 9
      }
    ]
  end

  def self.conflict
    [
      {
        question: 'When faced with a conflict of interest, an engineer should disclose it to all affected parties.',
        answer: true,
        template_id: 10
      }
    ]
  end
end

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
      input_fields: radio_input_fields,
      template_id: question_data[:template_id]
    }
  end

  def ethics_questions
    EngineeringEthicsQuestions.all_questions
  end

  def radio_input_fields
    [
      {
        label: 'Your Answer',
        key: 'ethics_answer',
        type: 'radio',
        options: radio_options
      }
    ]
  end

  def radio_options
    [
      { value: 'true', label: 'True' },
      { value: 'false', label: 'False' }
    ]
  end
end

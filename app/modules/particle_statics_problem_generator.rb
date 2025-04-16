class ParticleStaticsProblemGenerator
  attr_reader :category

  def initialize(category)
    @category = category
  end

  def generate_questions
    weighted_pool = (static_questions + (dynamic_questions * 3)).compact
    selected = weighted_pool.sample

    unless selected && selected[:input_fields].is_a?(Array) && selected[:input_fields].any?
      Rails.logger.warn("[ParticleStaticsProblemGenerator] Fallback triggered for question: #{selected.inspect}")
      selected = static_questions.sample
    end

    [selected]
  end

  private

  def generate_ps_problem_from_data(data)
    input_fields = if data[:input_type] == 'fill_in'
                     generate_fill_in_fields(data)
                   else
                     generate_multiple_choice_fields(data)
                   end

    {
      type: 'particle_statics',
      question: data[:question],
      answer: data[:answer],
      input_fields: input_fields,
      template_id: data[:template_id]
    }
  end

  def generate_fill_in_fields(data)
    answer = data[:answer]
    return generate_fill_in_fields_for_array(answer, data) if answer.is_a?(Array)

    generate_fill_in_fields_for_single(answer, data)
  end

  def generate_fill_in_fields_for_array(answer, data)
    if answer.all? { |ans| numeric?(ans) }
      answer.each_with_index.map do |_, i|
        { label: "Answer part #{i + 1}", key: "ps_answer_#{i + 1}", type: 'text' }
      end
    else
      [{ label: 'Your Answer', key: 'ps_answer', type: 'radio', options: data[:options] }]
    end
  end

  def generate_fill_in_fields_for_single(answer, data)
    if numeric?(answer)
      [{ label: data[:field_label] || 'Your Answer', key: 'ps_answer', type: 'text' }]
    else
      [{ label: 'Your Answer', key: 'ps_answer', type: 'radio', options: data[:options] }]
    end
  end

  def generate_multiple_choice_fields(data)
    [{ label: 'Your Answer', key: 'ps_answer', type: 'radio', options: data[:options] }]
  end

  def static_questions
    questions = [
      {
        question: 'A 10 kg object is suspended by two cables. What is the tension in each' \
                  'cable if the system is in equilibrium?',
        answer: %w[49 49],
        input_type: 'fill_in',
        field_label: 'Tension (N)',
        template_id: 1
      },
      {
        question: 'A 5 m beam is supported at both ends. A 500 N weight is placed 2 m from the left end. ' \
                  'What is the reaction force at the left support?',
        answer: '300',
        input_type: 'fill_in',
        field_label: 'Left Support Force (N)',
        template_id: 2
      },
      {
        question: 'A ladder leans against a frictionless wall. What must be the minimum coefficient of friction ' \
                  'at the base to prevent slipping?',
        answer: '0.45',
        input_type: 'fill_in',
        field_label: 'Coefficient of Friction',
        template_id: 3
      },
      {
        question: 'Which of the following is a condition for static equilibrium?',
        answer: 'A',
        input_type: 'multiple_choice',
        options: [
          { value: 'A', label: 'ΣF = 0 and ΣM = 0' },
          { value: 'B', label: 'ΣF ≠ 0 and ΣM = 0' },
          { value: 'C', label: 'ΣF = 0 and ΣM ≠ 0' },
          { value: 'D', label: 'None of the above' }
        ],
        template_id: 4
      },
      # Particle Statics Problems
      {
        question: 'A 100 N force is applied at the edge of a beam. What is the moment about the point of support ' \
                  '2 meters from the force?',
        answer: '200',
        input_type: 'fill_in',
        field_label: 'Moment (Nm)',
        template_id: 5
      },
      {
        question: 'A 50 kg object is in equilibrium. There are two forces acting on it. Force A is 100 N at an ' \
                  'angle of 30° and Force B is 150 N at 60°. What is the resultant force?',
        answer: '179.69',
        input_type: 'fill_in',
        field_label: 'Resultant Force (N)',
        template_id: 6
      }
    ]
    questions.map { |q| generate_ps_problem_from_data(q) }
  end

  def dynamic_questions
    [
      dynamic_question_one,
      dynamic_question_two
    ].compact
  end

  def dynamic_question_one
    mass = rand(5..15)
    g = 9.8
    tension = (mass * g / 2).round(2)

    generate_ps_problem_from_data({
                                    question: "A mass of #{mass} kg is suspended symmetrically by two " \
                                              'vertical ropes. What is the tension in each rope?',
                                    answer: tension.to_s,
                                    input_type: 'fill_in',
                                    field_label: 'Tension (N)',
                                    template_id: 7
                                  })
  end

  def dynamic_question_two
    force = rand(200..500)
    distance = rand(2..5)
    moment = (force * distance).round(2)

    generate_ps_problem_from_data({
                                    question: "A force of #{force} N is applied at a perpendicular distance of " \
                                              "#{distance} m from a pivot. What is the moment about the pivot?",
                                    answer: moment.to_s,
                                    input_type: 'fill_in',
                                    field_label: 'Moment (Nm)',
                                    template_id: 8
                                  })
  end

  def numeric?(str)
    Float(str)
    true
  rescue ArgumentError, TypeError
    false
  end
end

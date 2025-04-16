# rubocop:disable Metrics/MethodLength
class AngularMomentumProblemGenerator
  attr_reader :category

  def initialize(category)
    @category = category
  end

  def generate_questions
    weighted_pool = (static_questions + (dynamic_questions * 3)).compact
    selected = weighted_pool.sample

    unless selected && selected[:input_fields].is_a?(Array) && selected[:input_fields].any?
      Rails.logger.warn("[AngularMomentumProblemGenerator] Fallback triggered for question: #{selected.inspect}")
      selected = static_questions.sample
    end

    [selected]
  end

  private

  def generate_am_problem_from_data(data)
    input_fields = if data[:input_type] == 'fill_in'
                     generate_fill_in_fields(data)
                   else
                     generate_multiple_choice_fields(data)
                   end

    {
      type: 'angular_momentum',
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
        { label: "Answer part #{i + 1}", key: "am_answer_#{i + 1}", type: 'text' }
      end
    else
      [{ label: 'Your Answer', key: 'am_answer', type: 'radio', options: data[:options] }]
    end
  end

  def generate_fill_in_fields_for_single(answer, data)
    if numeric?(answer)
      [{ label: data[:field_label] || 'Your Answer', key: 'am_answer', type: 'text' }]
    else
      [{ label: 'Your Answer', key: 'am_answer', type: 'radio', options: data[:options] }]
    end
  end

  def generate_multiple_choice_fields(data)
    [{ label: 'Your Answer', key: 'am_answer', type: 'radio', options: data[:options] }]
  end

  def static_questions
    questions = [
      {
        question: 'A thin rod of length 0.20 m and mass 250 g rotates about an axis at one end. ' \
                  'What is the moment of inertia about this axis? (Use I = 1/3 mL²)',
        answer: '3.3',
        input_type: 'fill_in',
        field_label: 'Moment of Inertia (gm²)',
        template_id: 1
      },
      {
        question: 'Two objects move as follows: Object 1 has m=6.0 kg, v=2.0 m/s, d=1.5 m; ' \
                  'Object 2 has m=3.0 kg, v=3.5 m/s, d=2.5 m. ' \
                  'What is the total angular momentum about point A?',
        answer: '8.25',
        input_type: 'fill_in',
        field_label: 'Angular Momentum (kg·m²/s)',
        template_id: 2
      },
      {
        question: 'A person stands on a rotating platform at 1.2 rev/s. ' \
                  'Moment of inertia decreases from 6.0 to 2.0 kg·m². What is the new angular speed?',
        answer: '3.6',
        input_type: 'fill_in',
        field_label: 'New Angular Speed (rev/s)',
        template_id: 3
      },
      {
        question: 'A flywheel with I=0.140 kg·m² decreases from 3.00 to 0.800 kg·m²/s in 1.50 s. ' \
                  'What is the average torque?',
        answer: '-1.47',
        input_type: 'fill_in',
        field_label: 'Torque (Nm)',
        template_id: 4
      },
      {
        question: 'Using the same flywheel problem (I = 0.140 kg·m²), what is the angular displacement over 1.50 s ' \
                  'if angular acceleration is constant?',
        answer: '20.4',
        input_type: 'fill_in',
        field_label: 'Angular Displacement (rad)',
        template_id: 5
      },
      {
        question: 'In the flywheel problem (I = 0.140 kg·m², L changes from 3.00 to 0.800 kg·m²/s), ' \
                  'what is the work done on the flywheel?',
        answer: '-29.9',
        input_type: 'fill_in',
        field_label: 'Work Done (J)',
        template_id: 6
      },
      {
        question: 'What is the average power exerted on the flywheel from the same problem?',
        answer: '19.9',
        input_type: 'fill_in',
        field_label: 'Power (W)',
        template_id: 7
      },
      {
        question: 'In a sprocket-chain system of a bicycle, all points on the chain have the same linear speed. ' \
                  'If the front sprocket has 1.6 times the radius of the rear sprocket, what is the ratio of ' \
                  'angular speeds (ω_front / ω_rear)?',
        answer: '0.625',
        input_type: 'fill_in',
        field_label: 'Angular Speed Ratio',
        template_id: 8
      },
      {
        question: 'A kid displaces a hula hoop from rest by an angle θ and lets go. ' \
                  'What is the angular speed when it returns to equilibrium? Assume no friction.',
        answer: 'A',
        input_type: 'multiple_choice',
        options: [
          { value: 'A', label: '√(g(1 - cos(θ)) / r)' },
          { value: 'B', label: 'gθ / r' },
          { value: 'C', label: 'ω² = r/g' },
          { value: 'D', label: '1/2 m r² ω²' }
        ],
        template_id: 9
      }
    ]
    questions.map { |q| generate_am_problem_from_data(q) }
  end

  def dynamic_questions
    [
      dynamic_question_one,
      dynamic_question_two
    ].compact
  end

  def dynamic_question_one
    i = (1.0 + (rand * 4.0)).round(2)
    omega = (2.0 + (rand * 5.0)).round(2)
    l = (i * omega).round(2)
    return nil if i.zero? || omega.zero?

    generate_am_problem_from_data({
                                    question: "A rotating object has moment of inertia #{i} kg·m² and angular " \
                                              "velocity #{omega} rad/s. What is its angular momentum?",
                                    answer: l.to_s,
                                    input_type: 'fill_in',
                                    field_label: 'Angular Momentum (kg·m²/s)',
                                    template_id: 10
                                  })
  end

  def dynamic_question_two
    m = (2.0 + (rand * 3.0)).round(2)
    r = (0.2 + (rand * 0.8)).round(2)
    omega = (3.0 + (rand * 4.0)).round(2)
    i = (0.5 * m * (r**2)).round(3)
    l = (i * omega).round(2)
    return nil if m.zero? || r.zero? || omega.zero?

    generate_am_problem_from_data({
                                    question: "A solid disk (mass = #{m} kg, radius = #{r} m) rotates at #{omega}" \
                                              'rad/s. What is its angular momentum?',
                                    answer: l.to_s,
                                    input_type: 'fill_in',
                                    field_label: 'Angular Momentum (kg·m²/s)',
                                    template_id: 11
                                  })
  end

  def numeric?(str)
    Float(str)
    true
  rescue ArgumentError, TypeError
    false
  end
end
# rubocop:enable Metrics/MethodLength

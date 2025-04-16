# rubocop:disable Layout/LineLength, Naming/VariableNumber, Metrics/MethodLength

class HarmonicMotionProblemGenerator
  attr_reader :category

  def initialize(category)
    @category = category
  end

  def generate_questions
    weighted_pool = static_questions + (dynamic_questions * 3)
    [weighted_pool.sample]
  end

  private

  def generate_shm_problem_from_data(data)
    input_fields = if data[:input_type] == 'fill_in'
                     generate_fill_in_fields(data)
                   else
                     generate_multiple_choice_fields(data)
                   end

    {
      type: 'simple_harmonic_motion',
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
        { label: "Answer part #{i + 1}", key: "shm_answer_#{i + 1}", type: 'text' }
      end
    else
      [{ label: 'Your Answer', key: 'shm_answer', type: 'radio', options: data[:options] }]
    end
  end

  def generate_fill_in_fields_for_single(answer, data)
    if numeric?(answer)
      [{ label: data[:field_label] || 'Your Answer', key: 'shm_answer', type: 'text' }]
    else
      [{ label: 'Your Answer', key: 'shm_answer', type: 'radio', options: data[:options] }]
    end
  end

  def generate_multiple_choice_fields(data)
    [{ label: 'Your Answer', key: 'shm_answer', type: 'radio', options: data[:options] }]
  end

  def static_questions
    questions = [
      {
        question: 'In simple harmonic motion, the period T and angular frequency ω are related by:',
        answer: 'A',
        options: [
          { value: 'A', label: 'T = 2π/ω' },
          { value: 'B', label: 'T = ω/2π' },
          { value: 'C', label: 'T = 2πω' },
          { value: 'D', label: 'T = ω²/2π' }
        ],
        input_type: 'multiple_choice',
        template_id: 1
      },
      {
        question: 'For a simple pendulum undergoing small oscillations, which parameters determine its period?',
        answer: 'A',
        options: [
          { value: 'A', label: 'Length and gravitational acceleration' },
          { value: 'B', label: 'Mass and amplitude' },
          { value: 'C', label: 'Mass and length' },
          { value: 'D', label: 'Amplitude and gravitational acceleration' }
        ],
        input_type: 'multiple_choice',
        template_id: 2
      },
      {
        question: 'In a mass-spring system, if the mass is increased while the spring constant remains constant, the period:',
        answer: 'A',
        options: [
          { value: 'A', label: 'Increases' },
          { value: 'B', label: 'Decreases' },
          { value: 'C', label: 'Remains the same' },
          { value: 'D', label: 'Becomes zero' }
        ],
        input_type: 'multiple_choice',
        template_id: 3
      },
      {
        question: 'The damping in a simple harmonic oscillator generally causes the frequency to:',
        answer: 'A',
        options: [
          { value: 'A', label: 'Decrease slightly' },
          { value: 'B', label: 'Increase slightly' },
          { value: 'C', label: 'Remain unchanged' },
          { value: 'D', label: 'Oscillate unpredictably' }
        ],
        input_type: 'multiple_choice',
        template_id: 4
      },
      {
        question: 'Which statement is true regarding energy in an ideal (undamped) simple harmonic oscillator?',
        answer: 'A',
        options: [
          { value: 'A', label: 'Mechanical energy is conserved' },
          { value: 'B', label: 'Energy continuously increases' },
          { value: 'C', label: 'Energy continuously decreases' },
          { value: 'D', label: 'Energy is dissipated as heat' }
        ],
        input_type: 'multiple_choice',
        template_id: 5
      }
    ]
    questions.map { |q| generate_shm_problem_from_data(q) }
  end

  def dynamic_questions
    [
      dynamic_question_1,
      dynamic_question_2,
      dynamic_question_3,
      dynamic_question_4,
      dynamic_question_5,
      dynamic_question_6,
      dynamic_question_7,
      dynamic_question_8,
      dynamic_question_9,
      dynamic_question_10
    ]
  end

  # Q1: Vertical spring-mass SHM.
  def dynamic_question_1
    question_text = 'A small mass attached to a spring moves vertically with SHM described by d²y/dt² = -4π² y. Determine the period T (in seconds).'
    generate_shm_problem_from_data({
                                     question: question_text,
                                     answer: '1',
                                     input_type: 'fill_in',
                                     field_label: 'Period T',
                                     template_id: 6
                                   })
  end

  def dynamic_question_2
    mass = rand(10.0..15.0).round(1)
    k = rand(1200..1500)
    l_val = 2.0
    moment_inertia = (1.0 / 3.0) * mass * (l_val**2)
    period = (2 * Math::PI * Math.sqrt(moment_inertia / (k * (l_val**2)))).round(3)
    question_text = "A board of length #{l_val} m and mass #{mass} kg is pinned at one end and attached to a spring (k = #{k} N/m). Determine the period T (in seconds)."
    generate_shm_problem_from_data({
                                     question: question_text,
                                     answer: period.to_s,
                                     input_type: 'fill_in',
                                     field_label: 'Period T',
                                     template_id: 7
                                   })
  end

  def dynamic_question_3
    mass = (0.5 + (rand * 0.5)).round(2)
    k = (80 + (rand * 40)).round
    displacement = (0.20 + (rand * 0.10)).round(2)
    omega = Math.sqrt(k / mass)
    period = (2 * Math::PI / omega).round(3)
    question_text = "A #{mass} kg mass is attached to a horizontal spring (k = #{k} N/m) on a frictionless surface. It is pulled #{displacement} m from equilibrium and released. (a) What is the angular frequency ω (in rad/s)? (b) What is the period T (in seconds)?"
    generate_shm_problem_from_data({
                                     question: question_text,
                                     answer: [omega.round(3).to_s, period.to_s],
                                     input_type: 'fill_in',
                                     template_id: 8
                                   })
  end

  def dynamic_question_4
    l_val = (0.5 + (rand * 0.5)).round(2)
    g = 9.8
    period = (2 * Math::PI * Math.sqrt(l_val / g)).round(3)
    question_text = "A simple pendulum of length L = #{l_val} m swings (small amplitude) on Earth (g = 9.8 m/s²). Calculate the period T (in seconds)."
    generate_shm_problem_from_data({
                                     question: question_text,
                                     answer: period.to_s,
                                     input_type: 'fill_in',
                                     field_label: 'Period T',
                                     template_id: 9
                                   })
  end

  def dynamic_question_5
    mass = (1.8 + (rand * 0.4)).round(2)
    k = (150 + (rand * 20)).round
    omega = Math.sqrt(k / mass)
    frequency = (omega / (2 * Math::PI)).round(3)
    period = (1 / frequency).round(3)
    question_text = "A #{mass} kg mass is hung from a vertical spring (k = #{k} N/m) and released. (a) Determine the frequency f (in Hz). (b) Determine the period T (in seconds)."
    generate_shm_problem_from_data({
                                     question: question_text,
                                     answer: [frequency.to_s, period.to_s],
                                     input_type: 'fill_in',
                                     template_id: 10
                                   })
  end

  def dynamic_question_6
    l_val = (0.8 + (rand * 0.4)).round(2)
    mass = (1.8 + (rand * 0.4)).round(2)
    g = 9.8
    moment_inertia = (1.0 / 3.0) * mass * (l_val**2)
    h = l_val / 2.0
    period = (2 * Math::PI * Math.sqrt(moment_inertia / (mass * g * h))).round(3)
    question_text = "A uniform rod of length L = #{l_val} m and mass #{mass} kg is pivoted at one end. Determine the period T (in seconds)."
    generate_shm_problem_from_data({
                                     question: question_text,
                                     answer: period.to_s,
                                     input_type: 'fill_in',
                                     field_label: 'Period T',
                                     template_id: 11
                                   })
  end

  def dynamic_question_7
    mass = (0.18 + (rand * 0.04)).round(3)
    k = (50 + (rand * 10)).round
    displacement = (0.05 + (rand * 0.02)).round(3)
    omega = Math.sqrt(k / mass)
    period = (2 * Math::PI / omega).round(3)
    question_text = "A #{mass} kg mass is attached to a spring (k = #{k} N/m) on a frictionless track. It is displaced #{displacement} m from equilibrium and released. (a) What is the angular frequency ω (in rad/s)? (b) What is the period T (in seconds)?"
    generate_shm_problem_from_data({
                                     question: question_text,
                                     answer: [omega.round(3).to_s, period.to_s],
                                     input_type: 'fill_in',
                                     template_id: 12
                                   })
  end

  def dynamic_question_8
    l_val = (1.5 + (rand * 1.0)).round(2)
    g = 3.71
    period = (2 * Math::PI * Math.sqrt(l_val / g)).round(3)
    question_text = "A simple pendulum of length L = #{l_val} m swings on Mars (g = 3.71 m/s²). Calculate the period T (in seconds)."
    generate_shm_problem_from_data({
                                     question: question_text,
                                     answer: period.to_s,
                                     input_type: 'fill_in',
                                     field_label: 'Period T',
                                     template_id: 13
                                   })
  end

  def dynamic_question_9
    mass = (2.8 + (rand * 0.4)).round(2)
    k = (120 + (rand * 10)).round
    b = (1.1 + (rand * 0.2)).round(2)
    omega0 = Math.sqrt(k / mass)
    damped_term = (k / mass) - ((b**2) / (4 * (mass**2)))
    freq = (Math.sqrt(damped_term) / (2 * Math::PI)).round(3)
    freq_undamped = (omega0 / (2 * Math::PI)).round(3)
    question_text = "A #{mass} kg mass on a spring (k = #{k} N/m) experiences damping (b = #{b} kg/s). (a) Determine the damped frequency f (in Hz). (b) Determine the undamped frequency (in Hz)."
    generate_shm_problem_from_data({
                                     question: question_text,
                                     answer: [freq.to_s, freq_undamped.to_s],
                                     input_type: 'fill_in',
                                     template_id: 14
                                   })
  end

  def dynamic_question_10
    mass = (4.5 + (rand * 1.0)).round(2)
    k = (200 + (rand * 50)).round
    velocity = (1.5 + (rand * 1.0)).round(2)
    amplitude = (velocity * Math.sqrt(mass / k)).round(3)
    period = (2 * Math::PI * Math.sqrt(mass / k)).round(3)
    question_text = "A #{mass} kg block is attached to a horizontal spring (k = #{k} N/m) and starts at equilibrium moving right at #{velocity} m/s. (a) What is the amplitude (in meters)? (b) What is the period T (in seconds)?"
    generate_shm_problem_from_data({
                                     question: question_text,
                                     answer: [amplitude.to_s, period.to_s],
                                     input_type: 'fill_in',
                                     template_id: 15
                                   })
  end

  def numeric?(str)
    Float(str)
    true
  rescue ArgumentError, TypeError
    false
  end
end

# rubocop:enable Layout/LineLength, Naming/VariableNumber, Metrics/MethodLength

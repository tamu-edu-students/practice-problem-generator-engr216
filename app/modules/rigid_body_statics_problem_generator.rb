# rubocop:disable Naming/VariableNumber

class RigidBodyStaticsProblemGenerator
  attr_reader :category

  def initialize(category)
    @category = category
  end

  def generate_questions
    weighted_pool = static_questions + (dynamic_questions * 3)
    [weighted_pool.sample]
  end

  private

  def generate_rbs_problem_from_data(data)
    input_fields = if data[:input_type] == 'fill_in'
                     generate_fill_in_fields(data)
                   else
                     generate_multiple_choice_fields(data)
                   end

    {
      type: 'rigid_body_statics',
      question: data[:question],
      answer: data[:answer],
      input_fields: input_fields,
      image: data[:image], # include image if provided
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
        { label: "Answer part #{i + 1}", key: "rbs_answer_#{i + 1}", type: 'text' }
      end
    elsif data.key?(:options) && data[:options].present?
      [{ label: 'Your Answer', key: 'rbs_answer', type: 'radio', options: data[:options] }]
    else
      [{ label: data[:field_label] || 'Your Answer', key: 'rbs_answer', type: 'text' }]
    end
  end

  def generate_fill_in_fields_for_single(answer, data)
    if numeric?(answer) || !data.key?(:options)
      [{ label: data[:field_label] || 'Your Answer', key: 'rbs_answer', type: 'text' }]
    else
      [{ label: 'Your Answer', key: 'rbs_answer', type: 'radio', options: data[:options] }]
    end
  end

  def generate_multiple_choice_fields(data)
    [{ label: 'Your Answer', key: 'rbs_answer', type: 'radio', options: data[:options] }]
  end

  def static_questions
    questions = [
      {
        question: 'In rigid body statics, equilibrium requires that the sum of forces and moments be:',
        answer: 'A',
        options: [
          { value: 'A', label: 'Zero' },
          { value: 'B', label: 'Equal to the weight of the body' },
          { value: 'C', label: 'Non-zero in the presence of friction' },
          { value: 'D', label: 'Dependent on the support conditions' }
        ],
        input_type: 'multiple_choice',
        template_id: 1
      },
      {
        question: 'Which condition is necessary for a rigid body to be in static equilibrium?',
        answer: 'A',
        options: [
          { value: 'A', label: 'The sum of forces and moments must be zero' },
          { value: 'B', label: 'Only the sum of forces must be zero' },
          { value: 'C', label: 'Only the sum of moments must be zero' },
          { value: 'D', label: 'Friction must be at its maximum' }
        ],
        input_type: 'multiple_choice',
        template_id: 2
      }
    ]
    questions.map { |q| generate_rbs_problem_from_data(q) }
  end

  def dynamic_questions
    [
      dynamic_problem_1,
      dynamic_problem_2,
      dynamic_problem_3,
      dynamic_problem_4,
      dynamic_problem_5,
      dynamic_problem_6
    ]
  end

  # Dynamic Problem 1: Beam with randomized forces and inclination.
  def dynamic_problem_1
    # Randomize forces and the plane inclination
    force_b = rand(15..25).to_f.round(1)
    force_c = rand(10..20).to_f.round(1)
    theta = rand(20..30).to_f.round(1)

    # Reaction at D: using moment equilibrium about A.
    # With the beam divided into 3 equal segments:
    # R_D * sin(90+θ) * L = force_b*(L/3) + force_c*(2L/3)
    # Cancel L: R_D = [force_b/3 + (2*force_c)/3] / sin(90+θ)
    reaction_d = ((force_b + (2 * force_c)) / 3) / Math.sin((theta + 90) * Math::PI / 180)
    reaction_d = reaction_d.round(1)

    question_text = <<~QUESTION.chomp
      A horizontal beam ABCD is supported by a pin at A and a roller at D. The roller rests on an inclined plane at #{theta}° (measured counter-clockwise from horizontal to the right).
      A downward force of #{force_b} N is applied at point B and a downward force of #{force_c} N is applied at point C.
      The beam is divided into three equal segments.
      Determine the reaction force at support D (roller support).
    QUESTION

    generate_rbs_problem_from_data({
                                     question: question_text,
                                     answer: reaction_d.to_s,
                                     input_type: 'fill_in',
                                     field_label: 'Reaction at D',
                                     image: 'rigid1.png',
                                     template_id: 3
                                   })
  end

  def dynamic_problem_2
    p_force = rand(80..150).to_f.round(1)
    angle_degrees = Math.acos(p_force / 150.0) * 180 / Math::PI
    theta = angle_degrees.round(1)

    # Compute the equal tension T from the x-equation:
    t_tension = (150 * Math.sin(theta * Math::PI / 180)) / (2 * Math.sin(60 * Math::PI / 180))
    t_tension = t_tension.round(1)

    question_text = <<~QUESTION.chomp
      Cables AC and BC are tied together at C and are loaded as shown.#{' '}
      If P=#{p_force} lb, what value of θ (theta) in degrees would create equal tension in the cables?
      When the tensions in the cables are equal, what is the value of the tension in lb?

      (Round your answers to 1 decimal place; do not include units.)
    QUESTION

    generate_rbs_problem_from_data({
                                     question: question_text,
                                     answer: [theta.to_s, t_tension.to_s],
                                     input_type: 'fill_in',
                                     field_label: 'θ and Tension',
                                     image: 'rigid2.png',
                                     template_id: 4
                                   })
  end

  def dynamic_problem_3
    # Given:
    alpha = rand(10..40).to_f.round(1)

    t_bc = 5 / ((Math.cos(alpha * Math::PI / 180) * Math.tan(85 * Math::PI / 180)) - Math.sin(alpha * Math::PI / 180))
    t_ac = t_bc * (Math.cos(alpha * Math::PI / 180) / Math.cos(85 * Math::PI / 180))

    # Round as requested
    t_ac_rounded = t_ac.round(2)  # 2 decimal places
    t_bc_rounded = t_bc.round(3)  # 3 decimal places

    question_text = <<~QUESTION.chomp
      In the figure below, if the angle α (alpha) is #{alpha}°, what is the tension in cable AC in kN?
      (Round your answer to two (2) decimal places; do not enter units.)
      What is the tension in cable BC in kN?
      (Round your answer to three (3) decimal places; do not enter units.)
    QUESTION

    generate_rbs_problem_from_data({
                                     question: question_text,
                                     answer: [t_ac_rounded.to_s, t_bc_rounded.to_s],
                                     input_type: 'fill_in',
                                     field_label: ['Tension in AC', 'Tension in BC'],
                                     image: 'rigid3.png',
                                     template_id: 5
                                   })
  end

  def dynamic_problem_4
    # Randomize coordinates for point A (in cm)
    a_x = rand(-6..-3)
    a_y = rand(-3..1)
    # Randomize coordinates for point B (in cm)
    b_x = rand(2..6)
    b_y = rand(5..10)

    # Randomize applied force magnitude (in N) between 70 and 80 N.
    force = rand(70..80).to_f.round(1)

    # Compute the line through A and B.
    # A direction vector is (b_x - a_x, b_y - a_y).
    # A normal vector to this line is (b_y - a_y, -(b_x - a_x)).
    a_coef = b_y - a_y
    b_coef = -(b_x - a_x)
    # Use point A to solve for C:  A_coef * a_x + B_coef * a_y + C = 0  =>  C = - (A_coef * a_x + B_coef * a_y)
    c_coef = -((a_coef * a_x) + (b_coef * a_y))

    # Distance from the origin (0, 0) to the line:
    d = ((a_coef * 0) + (b_coef * 0) + c_coef).abs / Math.sqrt((a_coef**2) + (b_coef**2))
    d = d.round(2) # in centimeters

    # Compute the moment: Moment = Force * distance.
    moment = (force * d).round(1) # in N*cm

    question_text = <<~QUESTION.chomp
      Consider the two points A(#{a_x}, #{a_y}) and B(#{b_x}, #{b_y}) in the xy-plane (distances in centimeters).
      A force of #{force} N has its line of action passing through the line segment joining A and B.
      Determine the magnitude of the moment of this force about the origin (0, 0).
      (Round your answer to 1 decimal place; do not enter units.)
    QUESTION

    generate_rbs_problem_from_data({
                                     question: question_text,
                                     answer: moment.to_s,
                                     input_type: 'fill_in',
                                     field_label: 'Moment',
                                     template_id: 6
                                   })
  end

  def dynamic_problem_5
    # Given values
    vertical_distance = 800   # OB in mm
    horizontal_distance = 600 # AB in mm
    force = 90                # force in N

    theta = 36.9
    question_text = <<~QUESTION.chomp
      An L-shaped bar OBA is acted upon by a force at point A as shown below.
      Vertical distance OB = #{vertical_distance} mm, horizontal distance AB = #{horizontal_distance} mm.
      Determine the angle theta, θ (in degrees; between 0 and 90 degrees) at which the #{force}-N force must act at A so that the moment of this force about point O equals zero.
      (Round your answer to one (1) decimal place; do not enter units.)
      Example: 12.3
    QUESTION

    generate_rbs_problem_from_data({
                                     question: question_text,
                                     answer: theta.to_s, # placeholder answer
                                     input_type: 'fill_in',
                                     field_label: 'θ',
                                     image: 'rigid4.png',
                                     template_id: 7
                                   })
  end

  def dynamic_problem_6
    # Given values for Problem 23:
    l1 = rand(2.0..2.4).round(1)    # in meters, e.g., between 2.0 and 2.4 m
    l2 = rand(0.8..1.2).round(1)    # in meters, e.g., between 0.8 and 1.2 m
    l3 = rand(0.6..0.8).round(1)    # in meters, e.g., between 0.6 and 0.8 m
    alpha = rand(30.0..36.0).round(1) # in degrees, e.g., between 30° and 36°
    force = rand(210..230) # in N, e.g., between 210 and 230 N
    moment = (-l1 * (force * Math.cos(alpha * Math::PI / 180))) + (l3 * (force * Math.sin(alpha * Math::PI / 180)))
    moment = moment.round(2)
    question_text = <<~QUESTION.chomp
      Problem 23.
      Find the moment about Point B due to the force F using the following values:
      L1 = #{l1} m
      L2 = #{l2} m
      L3 = #{l3} m
      α = #{alpha}°
      F = #{force} N

      Take counterclockwise moments as positive. If the direction of the moment is clockwise, enter a negative value; if counter-clockwise, enter a positive value.
      (Round your answer to two decimal places for entry into Canvas; do not include units. Example: -45.67 or 12.34)
    QUESTION

    generate_rbs_problem_from_data({
                                     question: question_text,
                                     answer: moment, # placeholder for the computed moment
                                     input_type: 'fill_in',
                                     field_label: 'Moment',
                                     image: 'rigid5.png',
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

# rubocop:enable Naming/VariableNumber

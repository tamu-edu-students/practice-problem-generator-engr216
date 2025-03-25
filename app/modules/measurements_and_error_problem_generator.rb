class MeasurementsAndErrorProblemGenerator
  attr_reader :category

  def initialize(category)
    @category = category
  end

  # Returns an array containing one randomly selected question
  def generate_questions
    # Multiply dynamic questions array to weight its frequency higher.
    weighted_pool = static_questions + (dynamic_questions * 3)
    [weighted_pool.sample]
  end

  private

  # Helper method: builds a standardized question hash from given data.
  # If :input_type is "fill_in", it creates a text field.
  # Otherwise, it assumes a multiple choice question and builds a radio-button group.
  def generate_measurements_problem_from_data(data)
    input_fields =
      if data[:input_type] == 'fill_in'
        [{ label: data[:field_label] || 'Your Answer', key: 'measurement_answer', type: 'text' }]
      else
        [{ label: 'Your Answer', key: 'measurement_answer', type: 'radio', options: data[:options] }]
      end

    result = {
      type: 'measurements_error',
      question: data[:question],
      answer: data[:answer],
      input_fields: input_fields
    }
    result[:data_table] = data[:data_table] if data[:data_table]
    result
  end

  # --- Static Questions (Multiple Choice Only) ---
  def static_questions
    questions = [
      {
        question: 'Is there error in every measurement we take?',
        answer: 'A',
        options: [
          { value: 'A', label: 'Yes, every measurement has some uncertainty.' },
          { value: 'B', label: 'No, measurements can be perfectly exact.' },
          { value: 'C', label: 'Only when instruments are imprecise.' },
          { value: 'D', label: 'Only in experimental research.' }
        ],
        input_type: 'multiple_choice'
      },
      {
        question: 'Fill in the blank: The correct formula for the standard error is _____ .',
        answer: 'A',
        options: [
          { value: 'A', label: 'σ/√n' },
          { value: 'B', label: 'σ×√n' },
          { value: 'C', label: '(Maximum - Minimum)/n' },
          { value: 'D', label: 'n/σ' }
        ],
        input_type: 'multiple_choice'
      },
      {
        question: 'What are three ways to describe the center value of a dataset?',
        answer: 'A',
        options: [
          { value: 'A', label: 'Mean, Median, and Mode' },
          { value: 'B', label: 'Range, Standard Deviation, and Variance' },
          { value: 'C', label: 'Minimum, Maximum, and Average' },
          { value: 'D', label: 'Median, Mode, and Interquartile Range' }
        ],
        input_type: 'multiple_choice'
      },
      {
        question: 'What is the correct method to calculate the uncertainty of a measured value?',
        answer: 'A',
        options: [
          { value: 'A', label: 'Standard error = σ/√n' },
          { value: 'B', label: '(Highest value - Lowest value)/n' },
          { value: 'C', label: 'σ×√n' },
          { value: 'D', label: 'A value arbitrarily chosen based on the instrument' }
        ],
        input_type: 'multiple_choice'
      },
      {
        question: 'Fill in the blank: Calculate the sample mean for the values: x₁ = a + 3, x₂ = a, x₃ = a - 4, x₄ = a + 5, x₅ = a + 2. Express your answer in terms of a.',
        answer: 'A',
        options: [
          { value: 'A', label: 'a + 1.2' },
          { value: 'B', label: 'a + 1.4' },
          { value: 'C', label: 'a + 1.5' },
          { value: 'D', label: 'a + 1.75' }
        ],
        input_type: 'multiple_choice'
      }
    ]
    questions.map { |q| generate_measurements_problem_from_data(q) }
  end

  # --- Dynamic Questions (Numeric, Fill-In Text Field) ---
  def dynamic_questions
    [
      dynamic_question_1,
      dynamic_question_2,
      dynamic_question_3,
      dynamic_question_4
    ]
  end

  # Dynamic Question 1:
  # Q = (1 - x²) · cos((x + 2)/x³)
  def dynamic_question_1
    x = rand(1.50..2.00).round(2)
    delta_x = rand(0.01..0.05).round(2)
    f = ->(x_val) { (1 - (x_val**2)) * Math.cos((x_val + 2) / (x_val**3)) }
    epsilon = 0.0001
    derivative = ((f.call(x + epsilon) - f.call(x - epsilon)) / (2 * epsilon)).abs
    computed_uncertainty = (derivative * delta_x).round(3)
    question_text = "For Q = (1 - x²) · cos((x + 2)/x³) with x = #{x} ± #{delta_x}, what is the uncertainty in Q? (Round to three decimals)"
    generate_measurements_problem_from_data({
                                              question: question_text,
                                              answer: computed_uncertainty.to_s,
                                              input_type: 'fill_in',
                                              field_label: 'Uncertainty in Q'
                                            })
  end

  # Dynamic Question 2:
  # Q = (x + 2) / (x + y · cos(4θ))
  def dynamic_question_2
    x = rand(8.0..12.0).round(2)
    y = rand(6.0..8.0).round(2)
    theta_deg = rand(37.0..43.0).round(1)
    delta_x = 2.0
    delta_y = 1.0
    delta_theta_deg = 3.0
    theta = theta_deg * Math::PI / 180.0
    delta_theta = delta_theta_deg * Math::PI / 180.0
    f = ->(x_val, y_val, theta_val) { (x_val + 2) / (x_val + (y_val * Math.cos(4 * theta_val))) }
    epsilon = 0.0001
    dfdx = ((f.call(x + epsilon, y, theta) - f.call(x - epsilon, y, theta)) / (2 * epsilon)).abs
    dfdy = ((f.call(x, y + epsilon, theta) - f.call(x, y - epsilon, theta)) / (2 * epsilon)).abs
    dfdtheta = ((f.call(x, y, theta + epsilon) - f.call(x, y, theta - epsilon)) / (2 * epsilon)).abs
    uncertainty = Math.sqrt(((dfdx * delta_x)**2) + ((dfdy * delta_y)**2) + ((dfdtheta * delta_theta)**2))
    uncertainty = uncertainty.round(2)
    question_text = "For Q = (x + 2) / (x + y · cos(4θ)) with x = #{x} ± #{delta_x}, y = #{y} ± #{delta_y}, and θ = #{theta_deg}° ± #{delta_theta_deg}°, what is the uncertainty in Q? (Round to two decimals)"
    generate_measurements_problem_from_data({
                                              question: question_text,
                                              answer: uncertainty.to_s,
                                              input_type: 'fill_in',
                                              field_label: 'Uncertainty in Q'
                                            })
  end

  # Dynamic Question 3:
  # Volume uncertainty of a rectangular block.
  def dynamic_question_3
    l = rand(24.5..25.5).round(2)
    w = rand(12.0..13.0).round(2)
    h = rand(5.5..6.5).round(2)
    delta_l = 0.08
    delta_w = 0.03
    delta_h = 0.02
    volume = l * w * h
    relative_uncertainty = Math.sqrt(((delta_l / l)**2) + ((delta_w / w)**2) + ((delta_h / h)**2))
    uncertainty = (volume * relative_uncertainty).round(2)
    question_text = "If the dimensions of a rectangular block are measured as L = #{l} ± #{delta_l} mm, W = #{w} ± #{delta_w} mm, and H = #{h} ± #{delta_h} mm, what is the uncertainty in its volume? (Round to two decimals)"
    generate_measurements_problem_from_data({
                                              question: question_text,
                                              answer: uncertainty.to_s,
                                              input_type: 'fill_in',
                                              field_label: 'Volume Uncertainty'
                                            })
  end

  # Dynamic Question 4:
  # Standard error from a sample.
  def dynamic_question_4
    sample_mean = rand(60.0..65.0).round(2)
    std_dev = rand(2.0..3.0).round(2)
    sample_size = rand(8..15)
    standard_error = (std_dev / Math.sqrt(sample_size)).round(2)
    question_text = "Given a set of measurements with a sample mean of #{sample_mean}, a sample standard deviation of #{std_dev}, and #{sample_size} measurements, what is the uncertainty of the best estimate (standard error)? (Round to two decimals)"
    generate_measurements_problem_from_data({
                                              question: question_text,
                                              answer: standard_error.to_s,
                                              input_type: 'fill_in',
                                              field_label: 'Standard Error'
                                            })
  end
end

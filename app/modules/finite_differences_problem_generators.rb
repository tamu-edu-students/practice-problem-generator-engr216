# Main module that includes all finite differences problem generators
module FiniteDifferencesProblemGenerators
  # Include all the specific generator modules
  include FiniteDifferences::Base
  include FiniteDifferences::PolynomialProblems
  include FiniteDifferences::TrigProblems
  include FiniteDifferences::DataTableProblems
  include FiniteDifferences::SpecialFunctionProblems
  # Include utility modules
  include FiniteDifferences::PolynomialCalculations
  include FiniteDifferences::DataTableUtils

  # Remaining methods that don't fit into the categories above

  # Generate a problem for force vs time using backward difference
  def generate_force_vs_time_backward_problem
    # Generate data and calculate result
    data = generate_force_time_data
    rate_of_change = calculate_force_rate_of_change(data)

    # Create problem components
    data_table = create_force_data_table(data)
    question_text = force_vs_time_backward_text(data)

    # Build the problem
    build_finite_differences_problem(
      question_text,
      rate_of_change,
      params: { data_table: data_table, parameters: { answer: rate_of_change } },
      template_id: 10
    )
  end

  def generate_force_time_data
    t1 = rand(1..5)
    t2 = t1 + rand(1..3)
    {
      t1: t1,
      t2: t2,
      f1: rand(10..50),
      f2: rand(10..50)
    }
  end

  def calculate_force_rate_of_change(data)
    step_size = data[:t2] - data[:t1]
    ((data[:f2] - data[:f1]) / step_size).round(1)
  end

  def create_force_data_table(data)
    [
      ['Time (s)', data[:t1].to_s, data[:t2].to_s],
      ['Force (N)', data[:f1].to_s, data[:f2].to_s]
    ]
  end

  # Generate problem for all methods with function table
  def generate_function_table_all_methods_problem
    # Generate function values and calculate differences
    f_values = generate_function_values
    step_size = [0.5, 1.0, 2.0].sample
    differences = calculate_table_differences(f_values, step_size)

    # Create question text and build the problem
    question_text = create_function_table_question_text(f_values, step_size)
    build_function_table_problem(question_text, differences)
  end

  def create_function_table_question_text(f_values, step_size)
    function_table_all_methods_text({
                                      f_left: f_values[:left],
                                      f_center: f_values[:center],
                                      f_right: f_values[:right],
                                      h: step_size
                                    })
  end

  def build_function_table_problem(question_text, differences)
    build_finite_differences_problem(
      question_text,
      differences[:centered],
      params: { parameters: differences, input_fields: table_difference_input_fields },
      template_id: 6
    )
  end

  private

  def generate_function_values
    {
      left: rand(10..50),
      center: rand(10..50),
      right: rand(10..50)
    }
  end

  def calculate_table_differences(f_values, step_size)
    {
      forward: ((f_values[:right] - f_values[:center]) / step_size).round(0),
      backward: ((f_values[:center] - f_values[:left]) / step_size).round(0),
      centered: ((f_values[:right] - f_values[:left]) / (2 * step_size)).round(0)
    }
  end

  def table_difference_input_fields
    [
      { label: 'Forward Difference', key: 'forward' },
      { label: 'Backward Difference', key: 'backward' },
      { label: 'Centered Difference', key: 'centered' }
    ]
  end
end

class ErrorPropagationProblemGenerator
  attr_reader :category

  def initialize(category)
    @category = category
  end

  # Returns an array containing one randomly selected question
  def generate_questions
    # For fractional error problems
    fractional_methods = %i[
      kinetic_energy_fractional_problem
      gravitational_force_fractional_problem
      velocity_fractional_problem
      circular_area_problem
      spring_potential_energy_problem
      yo_yo_problem
    ]

    # For absolute uncertainty problems
    absolute_methods = %i[
      pendulum_period_problem
      projectile_range_problem
    ]

    # Choose whether to use a fractional or absolute method
    all_methods = rand > 0.5 ? fractional_methods : absolute_methods

    # Pick a random method
    method_name = all_methods.sample

    # Call the method on the module directly
    problem_data = ErrorPropagationProblemGenerators.send(method_name)

    # Convert to our standardized question format
    question = generate_problem_from_data(problem_data)

    [question]
  end

  private

  # Helper method to build a standardized question hash
  def generate_problem_from_data(data)
    input_fields = [
      { label: data[:field_label] || 'Uncertainty Value', key: 'answer', type: 'text' }
    ]

    {
      type: 'propagation of error',
      question: data[:question],
      answer: data[:answer],
      input_fields: input_fields,
      explanation: data[:explanation]
    }
  end

  # Generate single variable uncertainty problems
  def single_variable_problems
    ErrorPropagationProblemGenerators.single_variable_problems.map do |problem|
      generate_problem_from_data(problem)
    end
  end

  # Generate multi-variable uncertainty problems
  def multi_variable_problems
    ErrorPropagationProblemGenerators.multi_variable_problems.map do |problem|
      generate_problem_from_data(problem)
    end
  end

  # Generate fractional or relative error problems
  def fractional_error_problems
    ErrorPropagationProblemGenerators.fractional_error_problems.map do |problem|
      generate_problem_from_data(problem)
    end
  end
end

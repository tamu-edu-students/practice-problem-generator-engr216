# This class generates finite differences problems for students
class FiniteDifferencesProblemGenerator
  # Include the extracted modules
  include FiniteDifferencesQuestionText
  include AdvancedFiniteDifferencesText
  include FiniteDifferencesProblemGenerators

  def initialize(category)
    @category = category
    @last_used_generators = [] # Track recently used generators
  end

  # Generate a single finite differences problem
  def generate_questions
    [generate_finite_differences_problem]
  end

  private

  # Generate a random finite differences problem
  def generate_finite_differences_problem
    generator_list = available_generator_list
    selected_generator = choose_generator(generator_list)
    problem = send(:"generate_#{selected_generator}_problem")
    add_debug_info(problem, selected_generator) if Rails.env.development?
    problem
  end

  # Get list of available generator methods
  def available_generator_list
    verified_generators = verify_generator_methods(generator_methods_list)
    filter_recently_used_generators(verified_generators)
  end

  # List of all possible generator methods
  def generator_methods_list
    fundamental_generators + advanced_generators
  end

  # Basic finite difference generators
  def fundamental_generators
    %i[
      polynomial_all_approximations
      data_table_backward
      trig_function_centered
      force_vs_time_backward
      function_table_all_methods
    ]
  end

  # More specialized finite difference generators
  def advanced_generators
    %i[
      natural_log_derivative
      exponential_function_derivative
      velocity_profile_centered
      data_table_forward
      cooling_curve_centered
    ]
  end

  # Verify generators exist as methods
  def verify_generator_methods(all_generators)
    all_generators.select { |gen| respond_to?(:"generate_#{gen}_problem", true) }
  end

  # Filter out recently used generators
  def filter_recently_used_generators(verified_generators)
    available_generators = verified_generators - @last_used_generators
    available_generators = verified_generators if available_generators.empty?
    available_generators
  end

  # Choose a generator and track it
  def choose_generator(available_generators)
    selected_generator = available_generators.sample
    @last_used_generators << selected_generator
    @last_used_generators = @last_used_generators.last(5)
    selected_generator
  end

  # Add debug info to problem in development
  def add_debug_info(problem, selected_generator)
    correct_answer = if problem[:input_fields].length > 1
                       # Multiple answers case
                       problem[:input_fields].map do |field|
                         "#{field[:label]}: #{problem[:parameters][field[:key].to_sym]}"
                       end.join(', ')
                     else
                       # Single answer case
                       problem[:answer].to_s
                     end
    problem[:debug_info] = "Method: #{selected_generator}, Correct answer: #{correct_answer}"
  end

  # Build the base structure for finite differences problems
  def build_finite_differences_problem(question_text, answer, params = {})
    result = {
      type: 'finite_differences',
      question: question_text,
      answer: answer,
      input_fields: params[:input_fields] || default_input_field,
      parameters: params[:parameters] || {}
    }
    result[:data_table] = params[:data_table] if params[:data_table]
    result
  end

  # Default single input field for problems expecting one numerical answer
  def default_input_field
    [{ label: 'Answer', key: 'answer' }]
  end

  # Helper method to calculate forward difference
  def forward_difference(f_x, f_x_plus_h, step_size)
    (f_x_plus_h - f_x) / step_size
  end

  # Helper method to calculate backward difference
  def backward_difference(f_x, f_x_minus_h, step_size)
    (f_x - f_x_minus_h) / step_size
  end

  # Helper method to calculate centered difference
  def centered_difference(f_x_plus_h, f_x_minus_h, step_size)
    (f_x_plus_h - f_x_minus_h) / (2 * step_size)
  end

  # Calculate the derivative of a polynomial function
  def polynomial_derivative(coefficients, x_val)
    result = 0
    coefficients.each_with_index do |coef, power|
      # Skip the constant term (power 0)
      next if power.zero?

      # For each term, multiply coefficient by power and reduce power by 1
      result += coef * power * (x_val**(power - 1))
    end
    result
  end
end

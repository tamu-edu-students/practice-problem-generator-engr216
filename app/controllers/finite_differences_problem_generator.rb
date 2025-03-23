# This class generates finite differences problems for students
class FiniteDifferencesProblemGenerator
  # Include the extracted modules
  include FiniteDifferencesQuestionText
  include FiniteDifferencesProblemGenerators

  def initialize(category)
    @category = category
    @last_used_generators = []  # Track recently used generators
  end

  # Generate a single finite differences problem
  def generate_questions
    [generate_finite_differences_problem]
  end

  private

  # Generate a random finite differences problem
  def generate_finite_differences_problem
    # Include ONLY the methods that actually exist in the module
    all_generators = %i[
      polynomial_all_approximations
      data_table_backward
      trig_function_centered
      force_vs_time_backward
      function_table_all_methods
      natural_log_derivative
      exponential_function_derivative
      velocity_profile_centered
      data_table_forward
    ]

    # Validate that all generators actually exist as methods
    verified_generators = all_generators.select do |gen|
      respond_to?(:"generate_#{gen}_problem", true)
    end

    # Filter out recently used generators to avoid repetition
    available_generators = verified_generators - @last_used_generators
    
    # If we've used all generators, reset the tracking
    available_generators = verified_generators if available_generators.empty?
    
    # Choose a random generator from available ones
    selected_generator = available_generators.sample
    
    # Update the recently used list (keep last 3)
    @last_used_generators << selected_generator
    @last_used_generators = @last_used_generators.last(3)
    
    # Generate the problem using the selected generator
    problem = send(:"generate_#{selected_generator}_problem")
    
    # Add debug info for correct answer
    if Rails.env.development?
      correct_answer = if problem[:input_fields].length > 1
                         # Multiple answers case
                         problem[:input_fields].map do |field|
                           "#{field[:label]}: #{problem[:parameters][field[:key].to_sym]}"
                         end.join(", ")
                       else
                         # Single answer case
                         problem[:answer].to_s
                       end
      
      problem[:debug_info] = "Method: #{selected_generator}, Correct answer: #{correct_answer}"
    end
    
    problem
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
    
    # Make sure data_table is properly added if it exists in params
    result[:data_table] = params[:data_table] if params[:data_table]
    
    result
  end

  # Default single input field for problems expecting one numerical answer
  def default_input_field
    [{ label: 'Answer', key: 'answer' }]
  end

  # Helper method to calculate forward difference
  def forward_difference(f_x, f_x_plus_h, h)
    (f_x_plus_h - f_x) / h
  end

  # Helper method to calculate backward difference
  def backward_difference(f_x, f_x_minus_h, h)
    (f_x - f_x_minus_h) / h
  end

  # Helper method to calculate centered difference
  def centered_difference(f_x_plus_h, f_x_minus_h, h)
    (f_x_plus_h - f_x_minus_h) / (2 * h)
  end

  # Calculate the derivative of a polynomial function
  def polynomial_derivative(coefficients, x)
    result = 0
    coefficients.each_with_index do |coef, power|
      # Skip the constant term (power 0)
      next if power == 0
      # For each term, multiply coefficient by power and reduce power by 1
      result += coef * power * (x**(power - 1))
    end
    result
  end
end 
# Module for polynomial-related finite difference problems
module FiniteDifferences
  # Helper module for polynomial calculations
  module PolynomialCalculations
    def polynomial_function(coeffs)
      lambda do |x|
        (coeffs[:a] * (x**3)) +
          (coeffs[:b] * (x**2)) +
          (coeffs[:c] * x) +
          coeffs[:d]
      end
    end

    def polynomial_derivative_function(coeffs)
      lambda do |x|
        (3 * coeffs[:a] * (x**2)) +
          (2 * coeffs[:b] * x) +
          coeffs[:c]
      end
    end

    def calculate_forward_approx(func_values, step_size)
      ((func_values[:f_x_plus_h] - func_values[:f_x]) / step_size).round
    end

    def calculate_backward_approx(func_values, step_size)
      ((func_values[:f_x] - func_values[:f_x_minus_h]) / step_size).round
    end

    def calculate_centered_approx(func_values, step_size)
      ((func_values[:f_x_plus_h] - func_values[:f_x_minus_h]) / (2 * step_size)).round
    end
  end

  # Main module for polynomial problems
  module PolynomialProblems
    include PolynomialCalculations

    # Generate a problem comparing all approximation methods for polynomials
    def generate_polynomial_all_approximations_problem
      coefficients = generate_polynomial_coefficients
      params = generate_evaluation_params

      # Calculate differences and prepare parameters
      differences = calculate_polynomial_differences(
        coefficients,
        params[:x0],
        params[:step_size]
      )

      # Get question parameters and text
      question_params = prepare_question_params(coefficients, params)
      question_text = polynomial_all_approximations_text(question_params)

      # Build the complete problem
      build_polynomial_problem(question_text, differences)
    end

    def prepare_question_params(coefficients, params)
      coefficients.merge(
        x0: params[:x0],
        h: format_decimal(params[:step_size])
      )
    end

    def build_polynomial_problem(question_text, differences)
      build_finite_differences_problem(
        question_text,
        differences[:true_value],
        parameters: create_polynomial_parameters(differences),
        input_fields: polynomial_input_fields
      )
    end

    def create_polynomial_parameters(differences)
      {
        forward_diff: differences[:forward],
        backward_diff: differences[:backward],
        centered_diff: differences[:centered],
        true_derivative: differences[:true_value]
      }
    end

    # Generate a problem comparing different methods for quadratic functions
    def generate_quadratic_function_comparison_problem
      # Implementation with extracted helpers
      a = rand(1..10)
      b = rand(-5..5)
      c = rand(-10..10)

      # Create the question
      question_text = quadratic_function_comparison_text({
                                                           a: a, b: b, c: c
                                                         })

      # Define the correct answer
      true_value = 2 * a

      build_finite_differences_problem(question_text, true_value)
    end

    private

    def polynomial_input_fields
      [
        { label: 'Forward Difference', key: 'forward_diff' },
        { label: 'Backward Difference', key: 'backward_diff' },
        { label: 'Centered Difference', key: 'centered_diff' },
        { label: 'True Derivative', key: 'true_derivative' }
      ]
    end

    def generate_polynomial_coefficients
      {
        a: rand(5..30),
        b: rand(-15..15),
        c: rand(-10..10),
        d: rand(-100..100)
      }
    end

    def generate_evaluation_params
      {
        x0: rand(1..5),
        step_size: (0.1 * rand(1..5)).round(1)
      }
    end

    def calculate_polynomial_differences(coeffs, x_val, step_size)
      # Get function values
      func_values = calculate_func_values(coeffs, x_val, step_size)

      # Calculate approximations and true value
      calculate_approximations(func_values, step_size)
    end

    def calculate_func_values(coeffs, x_val, step_size)
      # Create function and derivative
      func = polynomial_function(coeffs)
      deriv = polynomial_derivative_function(coeffs)

      {
        f_x: func.call(x_val),
        f_x_plus_h: func.call(x_val + step_size),
        f_x_minus_h: func.call(x_val - step_size),
        true_deriv: deriv.call(x_val)
      }
    end

    def calculate_approximations(func_values, step_size)
      {
        forward: calculate_forward_approx(func_values, step_size),
        backward: calculate_backward_approx(func_values, step_size),
        centered: calculate_centered_approx(func_values, step_size),
        true_value: func_values[:true_deriv].round
      }
    end
  end
end

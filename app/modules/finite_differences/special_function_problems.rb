# Module for special function finite difference problems
module FiniteDifferences
  module SpecialFunctionProblems
    # Generate a natural log derivative problem
    def generate_natural_log_derivative_problem
      x0 = rand(2..10)
      step_size = [0.1, 0.2, 0.5].sample

      derivatives = calculate_natural_log_derivatives(x0, step_size)

      question_text = natural_log_derivative_text({ x0: x0, h: step_size })

      build_finite_differences_problem(
        question_text,
        derivatives[:true_derivative],
        parameters: derivatives,
        input_fields: natural_log_input_fields
      )
    end

    # Generate an exponential function derivative problem
    def generate_exponential_function_derivative_problem
      parameters = generate_exp_parameters
      derivatives = calculate_exponential_derivatives(parameters[:x0], parameters[:step_size])

      # Get question text
      question_text = create_exponential_question_text(parameters)

      # Build the problem
      build_exponential_problem(question_text, derivatives)
    end

    def generate_exp_parameters
      {
        x0: rand(1..10).to_f,
        step_size: (0.1 * rand(1..5)).round(2)
      }
    end

    def create_exponential_question_text(params)
      exponential_function_derivative_text({
                                             x0: params[:x0],
                                             h: format_decimal(params[:step_size])
                                           })
    end

    def build_exponential_problem(question_text, derivatives)
      build_finite_differences_problem(
        question_text,
        derivatives[:forward_diff],
        parameters: derivatives
      )
    end

    private

    def natural_log_input_fields
      [
        { label: 'Forward Difference', key: 'forward_diff' },
        { label: 'Backward Difference', key: 'backward_diff' },
        { label: 'Centered Difference', key: 'centered_diff' },
        { label: 'True Derivative', key: 'true_derivative' }
      ]
    end

    def calculate_natural_log_derivatives(x_val, step_size)
      # Calculate function values
      func_values = compute_log_function_values(x_val, step_size)

      # Calculate derivatives
      compute_log_derivatives(func_values, x_val, step_size)
    end

    def compute_log_function_values(x_val, step_size)
      {
        f_x: Math.log(x_val),
        f_x_plus_h: Math.log(x_val + step_size),
        f_x_minus_h: Math.log(x_val - step_size)
      }
    end

    def compute_log_derivatives(func, x_val, step_size)
      {
        forward_diff: compute_forward_log_diff(func, step_size),
        backward_diff: compute_backward_log_diff(func, step_size),
        centered_diff: compute_centered_log_diff(func, step_size),
        true_derivative: (1.0 / x_val).round(3)
      }
    end

    def compute_forward_log_diff(func, step_size)
      ((func[:f_x_plus_h] - func[:f_x]) / step_size).round(3)
    end

    def compute_backward_log_diff(func, step_size)
      ((func[:f_x] - func[:f_x_minus_h]) / step_size).round(3)
    end

    def compute_centered_log_diff(func, step_size)
      ((func[:f_x_plus_h] - func[:f_x_minus_h]) / (2 * step_size)).round(3)
    end

    def calculate_exponential_derivatives(x_val, step_size)
      # Get function values
      func_values = compute_exp_function_values(x_val, step_size)

      # Calculate derivatives
      {
        forward_diff: compute_forward_exp_diff(func_values, step_size),
        backward_diff: compute_backward_exp_diff(func_values, step_size),
        centered_diff: compute_centered_exp_diff(func_values, step_size)
      }
    end

    def compute_exp_function_values(x_val, step_size)
      exp_func = ->(x) { Math.exp(x) }

      {
        f_x: exp_func.call(x_val),
        f_x_plus_h: exp_func.call(x_val + step_size),
        f_x_minus_h: exp_func.call(x_val - step_size)
      }
    end

    def compute_forward_exp_diff(func, step_size)
      ((func[:f_x_plus_h] - func[:f_x]) / step_size).round(3)
    end

    def compute_backward_exp_diff(func, step_size)
      ((func[:f_x] - func[:f_x_minus_h]) / step_size).round(3)
    end

    def compute_centered_exp_diff(func, step_size)
      ((func[:f_x_plus_h] - func[:f_x_minus_h]) / (2 * step_size)).round(3)
    end
  end
end

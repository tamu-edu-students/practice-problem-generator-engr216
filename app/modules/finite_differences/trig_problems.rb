# Module for trigonometric function finite difference problems
module FiniteDifferences
  module TrigProblems
    # Generate a problem for trigonometric function using centered difference
    def generate_trig_function_centered_problem
      params = generate_trig_params

      # Calculate centered difference
      centered_diff = calculate_centered_diff_for_trig(params)

      # Create parameters and question
      question_params = format_trig_params(params)
      question_text = trig_function_centered_text(question_params)

      # Build the problem
      build_trig_centered_problem(question_text, centered_diff, question_params)
    end

    def calculate_centered_diff_for_trig(params)
      func = create_trig_function(params[:amplitude], params[:frequency])
      calculate_trig_centered_difference(
        func,
        params[:x_val],
        params[:step_size]
      )
    end

    def format_trig_params(params)
      {
        A: params[:amplitude],
        B: params[:frequency],
        x_val: params[:x_val],
        h: format_decimal(params[:step_size])
      }
    end

    def build_trig_centered_problem(question_text, centered_diff, params)
      build_finite_differences_problem(
        question_text,
        centered_diff,
        params: { parameters: params.merge(centered_diff: centered_diff) },
        template_id: 4
      )
    end

    private

    def generate_trig_params
      {
        amplitude: rand(1..10),
        frequency: rand(1..10),
        x_val: rand(1..5),
        step_size: (0.1 * rand(1..5)).round(1)
      }
    end

    def create_trig_function(amplitude, frequency)
      ->(x) { amplitude * Math.sin(frequency * x) }
    end

    def calculate_trig_centered_difference(func, x_val, step_size)
      f_plus_h = func.call(x_val + step_size)
      f_minus_h = func.call(x_val - step_size)
      ((f_plus_h - f_minus_h) / (2 * step_size)).round(2)
    end
  end
end

# Module containing text templates for basic finite differences problems
module FiniteDifferencesQuestionText
  def polynomial_all_approximations_text(params)
    # Format polynomial with proper signs
    polynomial = format_polynomial(params)

    <<~TEXT
      Use forward, backward, and centered difference approximations to estimate the first derivative of the following function:

      f(x) = #{polynomial}

      Evaluate the derivative at x = #{params[:x0]} using a step size of h = #{params[:h]}.
      Also calculate the true derivative value.

      Round your answer to zero (0) decimal places. Example: 2027
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def format_polynomial(params)
    polynomial = "#{params[:a]}x³"
    polynomial += params[:b] >= 0 ? " + #{params[:b]}x²" : " - #{params[:b].abs}x²"
    polynomial += params[:c] >= 0 ? " + #{params[:c]}x" : " - #{params[:c].abs}x"
    polynomial += params[:d] >= 0 ? " + #{params[:d]}" : " - #{params[:d].abs}"
    polynomial
  end

  def data_table_backward_text(params)
    <<~TEXT
      A heat exchanger is used to cool a liquid flowing through a pipeline. The temperature of the liquid at one point in the pipeline is measured over time and recorded in the table below. Using the data, calculate the change in temperature with time at point #{params[:point]} using a first order backward finite difference method.

      Round your answer to one (1) decimal place. Example: 12.3
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def trig_function_centered_text(params)
    <<~TEXT
      Estimate the derivative of the following function using the centered difference approximation:

      f(x) = #{params[:A]}sin(#{params[:B]}x)

      Evaluate the derivative at x = #{params[:x_val] || params[:x0]} using a step size of h = #{params[:h]}.

      Round your answer to two (2) decimal places. Example: 15.87
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def data_table_forward_text(params)
    <<~TEXT
      A sensor records the displacement of a falling object at equal time intervals. Using the table below, use a forward difference approximation to estimate the velocity at point #{params[:point]}.

      Round your answer to two (2) decimal places. Example: 15.87
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def quadratic_function_comparison_text(params)
    <<~TEXT
      Use the backward and forward difference approximations to estimate the derivative of f(x) = #{params[:a]}x² + #{params[:b]}x + #{params[:c]} at x = #{params[:x0]}, using h = #{params[:h]}. Also compute the true derivative for comparison.

      Round your answers to one (1) decimal place. Example: 32.7
      Do not include units. Do not use scientific notation.
    TEXT
  end

  # Helper for properly formatting step sizes
  def format_step_size(step_size)
    if step_size.to_i == step_size
      step_size.to_i.to_s # Show as integer if it's a whole number
    else
      # Ensure decimal numbers display with leading zero
      step_size_str = step_size.to_s
      step_size_str.start_with?('.') ? "0#{step_size_str}" : step_size_str
    end
  end

  def function_table_all_methods_text(params)
    <<~TEXT
      Given the following function values:

      f(x-h) = #{params[:f_left]}
      f(x) = #{params[:f_center]}
      f(x+h) = #{params[:f_right]}

      Where the step size is h = #{format_step_size(params[:h])}

      Calculate the derivative f'(x) using the forward, backward, and centered difference methods.

      Round your answer to zero (0) decimal places. Example: 42
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def displacement_forward_text(params)
    <<~TEXT
      A sensor records the displacement of a falling object at equal time intervals. Using the table below, use a forward difference approximation to estimate the velocity at point #{params[:point]}.

      Round your answer to two (2) decimal places. Example: 15.87
      Do not include units. Do not use scientific notation.
    TEXT
  end
end

# Module containing specialized/advanced finite differences question text
module AdvancedFiniteDifferencesText
  def velocity_profile_centered_text(params)
    <<~TEXT
      A car's speed at different positions is given in the table. Estimate the acceleration at position #{params[:position]} using the centered difference method.

      Round your answer to one (1) decimal place. Example: 12.3
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def cooling_curve_centered_text(params)
    <<~TEXT
      In a cooling experiment, the temperature of an object is recorded every #{params[:dt]} seconds. Use the centered difference method to estimate the cooling rate at the third time point.

      Round your answer to one (1) decimal place. Example: 9.4
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def natural_log_derivative_text(params)
    <<~TEXT
      Estimate the derivative of the natural logarithm function:

      f(x) = ln(x)

      Evaluate at x = #{params[:x0]} using forward, backward, and centered difference methods with step size h = #{format_step_size(params[:h])}.
      Also calculate the true derivative value.

      Round each answer to three (3) decimal places. Example: 0.693
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def exponential_function_derivative_text(params)
    <<~TEXT
      Estimate the derivative of the exponential function:

      f(x) = e^x

      Evaluate at x = #{params[:x0]} with step size h = #{params[:h]}.

      Round each answer to three (3) decimal places. Example: 2.718
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def force_vs_time_backward_text(params)
    <<~TEXT
      A force sensor records values at different times. Using the data table, estimate the rate of change of force with respect to time at time t = #{params[:t2]} using the backward difference method.

      Round your answer to one (1) decimal place. Example: 5.2
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def function_table_all_methods_text(params)
    <<~TEXT
      Given the following function values:

      f(x-h) = #{params[:f_left]}
      f(x) = #{params[:f_center]}
      f(x+h) = #{params[:f_right]}

      Where the step size is h = #{format_step_size(params[:h])}

      Calculate the derivative f'(x) using the forward, backward, and centered difference methods.

      Round your answer to zero (0) decimal places. Example: 42
      Do not include units. Do not use scientific notation.
    TEXT
  end

  # Helper method to format step sizes (duplicated from FiniteDifferencesQuestionText for module independence)
  def format_step_size(step_size)
    if step_size.to_i == step_size
      step_size.to_i.to_s # Show as integer if it's a whole number
    else
      # Ensure decimal numbers display with leading zero
      step_size_str = step_size.to_s
      step_size_str.start_with?('.') ? "0#{step_size_str}" : step_size_str
    end
  end
end

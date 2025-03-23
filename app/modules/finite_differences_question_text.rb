# Module containing text templates for finite differences problems
module FiniteDifferencesQuestionText
  def polynomial_all_approximations_text(params)
    <<~TEXT
      Use forward, backward, and centered difference approximations to estimate the first derivative of the following function:

      f(x) = #{params[:a]}x³ + #{params[:b]}x² + #{params[:c]}x + #{params[:d]}

      Evaluate the derivative at x = #{params[:x0]} using a step size of h = #{params[:h]}.
      Also calculate the true derivative value.
      Round your answer to zero (0) decimal places. Example: 2027
      Do not include units. Do not use scientific notation.
    TEXT
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
      Estimate the derivative of f(x) = #{params[:A]}sin(#{params[:B]}x) at x = #{params[:x0]} using the centered difference approximation with step size h = #{params[:h]}.
      
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

  def velocity_profile_centered_text(params)
    <<~TEXT
      A car's speed at different positions is given in the table. Estimate the acceleration at position #{params[:pos]} using the centered difference method.
      
      Round your answer to one (1) decimal place. Example: 12.3
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def natural_log_derivative_text(params)
    <<~TEXT
      Estimate the derivative of f(x) = ln(x) at x = #{params[:x0]} using forward, backward, and centered difference methods with h = #{params[:h]}.
      
      Round each answer to three (3) decimal places. Example: 0.693
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def force_vs_time_backward_text(params)
    <<~TEXT
      You are given force measurements over time as shown. Use a first-order backward finite difference method to estimate the rate of change of force at time #{params[:t2]}.
      
      Round your answer to one (1) decimal place. Example: 12.3
      Do not include units. Do not use scientific notation.
    TEXT
  end

  def function_table_all_methods_text(params)
    <<~TEXT
      Given the following values of a function: f(x - h) = #{params[:f_left]}, f(x) = #{params[:f_center]}, f(x + h) = #{params[:f_right]}
      
      Estimate the derivative at x using forward, backward, and centered difference methods. Let h = #{params[:h]}.
      Round all answers to zero (0) decimal places. Example: 207
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
end 
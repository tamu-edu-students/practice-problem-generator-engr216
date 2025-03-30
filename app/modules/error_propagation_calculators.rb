module ErrorPropagationCalculators
  module_function

  # Calculate uncertainty for a single variable function
  # @param derivative [Float] The value of the derivative at the point
  # @param uncertainty [Float] The uncertainty in the input variable
  # @return [Float] The calculated uncertainty in the output, rounded to 3 decimal places
  def calculate_uncertainty(derivative, uncertainty)
    (derivative.abs * uncertainty).round(3)
  end

  # Calculate combined uncertainty for a multi-variable function
  # @param derivatives [Array<Float>] Array of partial derivative values
  # @param uncertainties [Array<Float>] Array of uncertainties for each variable
  # @return [Float] The calculated combined uncertainty, rounded to 3 decimal places
  def calculate_combined_uncertainty(derivatives, uncertainties)
    # Check if arrays have same length
    raise ArgumentError, 'Arrays must have same length' if derivatives.length != uncertainties.length

    # Calculate the sum of squares
    sum_of_squares = derivatives.zip(uncertainties).sum do |derivative, uncertainty|
      (derivative * uncertainty)**2
    end

    # Return the square root of the sum, rounded to 3 decimal places
    Math.sqrt(sum_of_squares).round(3)
  end

  # Calculate fractional uncertainty
  # @param power [Float] The power of the variable in the function
  # @param fractional_uncertainty [Float] The fractional uncertainty in the input variable
  # @return [Float] The calculated fractional uncertainty in the output
  def calculate_fractional_uncertainty(power, fractional_uncertainty)
    (power.abs * fractional_uncertainty).round(1)
  end

  # Calculate the numerical derivative of a function at a point
  # @param func [Proc] The function to differentiate
  # @param point [Float] The point at which to evaluate the derivative
  # @param step [Float] The step size for the numerical differentiation (default: 0.0001)
  # @return [Float] The calculated derivative
  def numerical_derivative(func, point, step = 0.0001)
    (func.call(point + step) - func.call(point - step)) / (2 * step)
  end

  # Calculate the partial derivative of a multi-variable function with respect to a variable
  # @param func [Proc] The function to differentiate
  # @param vars [Array<Float>] The values of all variables
  # @param index [Integer] The index of the variable to differentiate with respect to
  # @param step [Float] The step size for the numerical differentiation (default: 0.0001)
  # @return [Float] The calculated partial derivative
  def numerical_partial_derivative(func, vars, index, step = 0.0001)
    vars_plus = vars.dup
    vars_minus = vars.dup
    vars_plus[index] += step
    vars_minus[index] -= step

    (func.call(*vars_plus) - func.call(*vars_minus)) / (2 * step)
  end
end

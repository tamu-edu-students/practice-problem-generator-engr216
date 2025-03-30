# rubocop:disable Layout/LineLength

module ErrorPropagationQuestionText
  module_function

  # Helper method to format formulas nicely
  def format_formula(formula)
    return formula if formula.include?('<sup>') || formula.include?('<sub>') # Skip if already formatted with HTML

    formatted = formula
    formatted = format_square_roots(formatted)
    formatted = format_fractions(formatted)
    formatted = format_exponents_and_subscripts(formatted)
    format_greek_letters(formatted)
  end

  # Format square roots in formulas
  def format_square_roots(formula)
    # Format double square roots and square roots with complex content
    formatted = formula.gsub(/√√\(([^()]+)\)/) do |_match|
      radicand = ::Regexp.last_match(1)
      "<span class=\"sqrt\"><span class=\"sqrt\"><span class=\"sqrt-content\">#{radicand}</span></span></span>"
    end

    # Format simple square roots
    formatted = formatted.gsub(/√\(([^()]+)\)/) do |_match|
      radicand = ::Regexp.last_match(1)
      "<span class=\"sqrt\"><span class=\"sqrt-content\">#{radicand}</span></span>"
    end

    # Format square roots without parentheses
    formatted.gsub(/√([a-zA-Z0-9×]+)/) do |_match|
      radicand = ::Regexp.last_match(1)
      "<span class=\"sqrt\"><span class=\"sqrt-content\">#{radicand}</span></span>"
    end
  end

  # Format fractions in formulas
  def format_fractions(formula)
    # Replace simple fractions with styled versions
    formatted = formula
                .gsub('(1/2)', '<span class="fraction"><span class="numerator">1</span><span class="denominator">2</span></span>')
                .gsub(%r{\(([^()]+)/([^()]+)\)}) do |_match|
      numerator = ::Regexp.last_match(1)
      denominator = ::Regexp.last_match(2)
      "<span class=\"fraction\"><span class=\"numerator\">#{numerator}</span><span class=\"denominator\">#{denominator}</span></span>"
    end

    # Format fractions not in parentheses
    formatted.gsub(%r{([a-zA-Z\d]+)/([a-zA-Z\d]+)}) do |match|
      if match.start_with?('<span') # Skip already formatted spans
        match
      else
        numerator = ::Regexp.last_match(1)
        denominator = ::Regexp.last_match(2)
        "<span class=\"math-fraction\">#{numerator}/#{denominator}</span>"
      end
    end
  end

  # Format exponents and subscripts in formulas
  def format_exponents_and_subscripts(formula)
    # Format superscripts for exponents (e.g., x² or x^2)
    formatted = formula.gsub(/(\w+)\^?(\d+)/) do |_match|
      base = ::Regexp.last_match(1)
      exponent = ::Regexp.last_match(2)
      "#{base}<sup>#{exponent}</sup>"
    end

    # Format subscripts
    formatted.gsub(/(\w+)_(\w+)/, '\1<sub>\2</sub>')
  end

  # Format Greek letters in formulas
  def format_greek_letters(formula)
    greek_letters = {
      'theta' => 'θ',
      'Theta' => 'Θ',
      'pi' => 'π',
      'Pi' => 'Π',
      'rho' => 'ρ',
      'Rho' => 'Ρ',
      'sigma' => 'σ',
      'Sigma' => 'Σ',
      'delta' => 'δ',
      'Delta' => 'Δ'
    }

    formatted = formula
    greek_letters.each do |text, symbol|
      formatted = formatted.gsub(/\b#{text}\b/, symbol)
    end
    formatted
  end

  # Template for single variable uncertainty problems
  def single_variable_template(context, formula, variable, value, uncertainty, units, physical_quantity, constant = nil)
    constant_part = constant.nil? ? '' : " Use #{constant[:symbol]} = #{constant[:value]} #{constant[:units]}."

    "The #{physical_quantity} of #{context} is given by #{format_formula(formula)}, where #{variable} = #{value} ± #{uncertainty} #{units}. Calculate the uncertainty of the #{physical_quantity}.#{constant_part}"
  end

  # Template for multi-variable uncertainty problems
  def multi_variable_template(physical_quantity, formula, variable_data)
    var1 = variable_data[:var1]
    val1 = variable_data[:val1]
    unc1 = variable_data[:unc1]
    unit1 = variable_data[:unit1]
    var2 = variable_data[:var2]
    val2 = variable_data[:val2]
    unc2 = variable_data[:unc2]
    unit2 = variable_data[:unit2]

    "The #{physical_quantity} is calculated using #{format_formula(formula)}. Given #{var1} = #{val1} ± #{unc1} #{unit1} and #{var2} = #{val2} ± #{unc2} #{unit2}, calculate the uncertainty of #{physical_quantity}."
  end

  # Template for fractional or relative error problems
  def fractional_error_template(physical_quantity, formula, variable, percentage)
    "The #{physical_quantity} is given by #{format_formula(formula)}. If the relative uncertainty of #{variable} is #{percentage}%, what is the relative uncertainty in the #{physical_quantity}?"
  end

  # Generate explanation for single variable uncertainty
  def single_variable_explanation(formula, derivative_formula, variable, value, uncertainty, result)
    <<~EXPLANATION
      To calculate the uncertainty in a derived quantity, we use the formula:

      δf = |df/d#{variable}| × δ#{variable}

      Where df/d#{variable} is the derivative of the function with respect to #{variable}.

      For our function #{format_formula(formula)}:

      The derivative is #{format_formula(derivative_formula)}

      Evaluating at #{variable} = #{value}:

      |df/d#{variable}| = #{format_formula(derivative_formula.gsub(variable, value.to_s).gsub('θ', (value * Math::PI / 180.0).to_s))}

      Multiplying by the uncertainty δ#{variable} = #{uncertainty}:

      δf = |df/d#{variable}| × δ#{variable} = #{result}
    EXPLANATION
  end

  # Generate explanation for multi-variable uncertainty
  def multi_variable_explanation(formula, derivatives, values, uncertainties, result)
    explanation = <<~EXPLANATION
      To calculate the uncertainty in a quantity with multiple variables, we use:

      δf = √[(∂f/∂x₁ × δx₁)² + (∂f/∂x₂ × δx₂)² + ...]

      For our function #{format_formula(formula)}:

    EXPLANATION

    # Add each partial derivative explanation
    derivatives.each_with_index do |derivative, i|
      var = "x#{i + 1}"
      explanation += "∂f/∂#{var} = #{format_formula(derivative)}, evaluated at #{var} = #{values[i]} gives |∂f/∂#{var}| × δ#{var} = #{format_formula(derivatives[i].gsub("x#{i + 1}", values[i].to_s))} × #{uncertainties[i]}\n\n"
    end

    explanation += <<~EXPLANATION

      Combining these terms under the square root:

      δf = √[(term1)² + (term2)² + ...] = #{result}
    EXPLANATION

    explanation
  end

  # Generate explanation for fractional error problems
  def fractional_error_explanation(formula, variable, power, result)
    <<~EXPLANATION
      For a quantity f = #{format_formula(formula)}, the relative uncertainty is related to the relative uncertainty in #{variable} by:

      (δf/f) = |n| × (δ#{variable}/#{variable})

      Where n is the power of #{variable} in the formula.

      In this case, n = #{power}, so:

      (δf/f) = |#{power}| × (δ#{variable}/#{variable}) = |#{power}| × #{variable == 'h' ? power / 100.0 : power}% = #{result}%
    EXPLANATION
  end
end

# rubocop:enable Layout/LineLength

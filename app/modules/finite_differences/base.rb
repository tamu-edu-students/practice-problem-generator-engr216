# Base module with common utilities for finite differences problems
module FiniteDifferences
  module Base
    # Format decimal numbers properly to avoid floating point precision issues
    def format_decimal(number)
      # Remove trailing zeros and decimal point if whole number
      formatted = format('%.10f', number).sub(/\.?0+$/, '')
      # If it still has a decimal part with many digits, truncate to 2 decimal places
      formatted = format('%.2f', number).sub(/\.?0+$/, '') if /\.\d{3,}$/.match?(formatted)
      formatted
    end

    # Build a finite differences problem with standard structure
    def build_finite_differences_problem(question_text, answer, template_id:, params: {})
      result = {
        type: 'finite_differences',
        question: question_text,
        answer: answer,
        input_fields: params[:input_fields] || default_input_field,
        parameters: params[:parameters] || {},
        template_id: template_id
      }
      result[:data_table] = params[:data_table] if params[:data_table]
      result
    end

    # Default input field for problems
    def default_input_field
      [{ label: 'Answer', key: 'answer' }]
    end

    # Calculate forward difference
    def forward_difference(function_value, function_value_plus_step, step_size)
      (function_value_plus_step - function_value) / step_size
    end

    # Calculate backward difference
    def backward_difference(function_value, function_value_minus_step, step_size)
      (function_value - function_value_minus_step) / step_size
    end

    # Calculate centered difference
    def centered_difference(function_value_plus_step, function_value_minus_step, step_size)
      (function_value_plus_step - function_value_minus_step) / (2 * step_size)
    end

    # Helper method to format a term without a sign
    def term_without_sign(coefficient, power)
      case power
      when 0
        coefficient.to_s
      when 1
        coefficient == 1 ? 'x' : "#{coefficient}x"
      else
        coefficient == 1 ? "x^#{power}" : "#{coefficient}x^#{power}"
      end
    end
  end
end

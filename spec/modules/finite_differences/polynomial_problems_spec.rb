require 'rails_helper'

RSpec.describe FiniteDifferences::PolynomialProblems do
  let(:test_class) do
    Class.new do
      include FiniteDifferences::Base
      include FiniteDifferences::PolynomialProblems

      # Stub for the text method
      def polynomial_all_approximations_text(_params)
        'Test polynomial question'
      end

      def quadratic_function_comparison_text(_params)
        'Test quadratic question'
      end
    end
  end

  let(:polynomial) { test_class.new }

  describe '#generate_polynomial_all_approximations_problem' do
    before do
      allow(polynomial).to receive(:rand).and_return(5)
    end

    it 'generates a problem with the correct type' do
      problem = polynomial.generate_polynomial_all_approximations_problem
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'uses the expected question text' do
      problem = polynomial.generate_polynomial_all_approximations_problem
      expect(problem[:question]).to eq('Test polynomial question')
    end

    it 'includes parameters for forward difference' do
      problem = polynomial.generate_polynomial_all_approximations_problem
      expect(problem[:parameters]).to have_key(:forward_diff)
    end

    it 'includes parameters for backward difference' do
      problem = polynomial.generate_polynomial_all_approximations_problem
      expect(problem[:parameters]).to have_key(:backward_diff)
    end

    it 'includes parameters for centered difference' do
      problem = polynomial.generate_polynomial_all_approximations_problem
      expect(problem[:parameters]).to have_key(:centered_diff)
    end

    it 'includes parameters for true derivative' do
      problem = polynomial.generate_polynomial_all_approximations_problem
      expect(problem[:parameters]).to have_key(:true_derivative)
    end
  end

  describe '#generate_quadratic_function_comparison_problem' do
    before do
      allow(polynomial).to receive(:rand).and_return(5)
    end

    it 'generates a problem with the correct type' do
      problem = polynomial.generate_quadratic_function_comparison_problem
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'uses the expected question text' do
      problem = polynomial.generate_quadratic_function_comparison_problem
      expect(problem[:question]).to eq('Test quadratic question')
    end

    it 'sets the answer to 2*a' do
      problem = polynomial.generate_quadratic_function_comparison_problem
      # should be 2*a where a=5
      expect(problem[:answer]).to eq(10)
    end
  end

  # Test private methods
  describe 'private methods' do
    it 'calculates polynomial differences correctly' do
      # Create coefficients for a simple polynomial: f(x) = x^3
      coeffs = { a: 1, b: 0, c: 0, d: 0 }

      differences = polynomial.send(:calculate_polynomial_differences, coeffs, 2, 1)

      # For f(x) = x^3, f'(x) = 3x^2
      # At x = 2, f'(2) = 3(2)^2 = 12
      expect(differences[:true_value]).to eq(12)
    end

    it 'generates polynomial functions correctly' do
      # f(x) = x^3 + 2x^2 + 3x + 4
      coeffs = { a: 1, b: 2, c: 3, d: 4 }

      f = polynomial.send(:polynomial_function, coeffs)

      # f(2) = 2^3 + 2(2)^2 + 3(2) + 4 = 8 + 8 + 6 + 4 = 26
      expect(f.call(2)).to eq(26)
    end

    it 'calculates derivatives correctly' do
      # f(x) = x^3 + 2x^2 + 3x + 4
      # f'(x) = 3x^2 + 4x + 3
      coeffs = { a: 1, b: 2, c: 3, d: 4 }

      df = polynomial.send(:polynomial_derivative_function, coeffs)

      # f'(2) = 3(2)^2 + 4(2) + 3 = 12 + 8 + 3 = 23
      expect(df.call(2)).to eq(23)
    end
  end
end

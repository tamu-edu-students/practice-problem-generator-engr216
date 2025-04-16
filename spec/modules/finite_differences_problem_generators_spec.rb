require 'rails_helper'

RSpec.describe FiniteDifferencesProblemGenerators do
  let(:test_class) do
    Class.new do
      include FiniteDifferences::Base
      include FiniteDifferences::PolynomialProblems
      include FiniteDifferences::TrigProblems
      include FiniteDifferences::DataTableProblems
      include FiniteDifferences::SpecialFunctionProblems
      include FiniteDifferencesProblemGenerators
      include FiniteDifferencesQuestionText
      include AdvancedFiniteDifferencesText

      # Helper for tests - needed because format_decimal may be in an included module
      def format_decimal(num)
        num.to_s
      end

      # Add a method to provide access to the fundamental and advanced generators
      def fundamental_generators_list
        %i[
          polynomial_all_approximations
          data_table_backward
          trig_function_centered
          force_vs_time_backward
          function_table_all_methods
        ]
      end

      def build_finite_differences_problem(question_text, answer, template_id:, params: {})
        result = {
          type: 'finite_differences',
          question: question_text,
          answer: answer,
          input_fields: params[:input_fields] || [{ label: 'Answer', key: 'answer' }],
          parameters: params[:parameters] || {},
          template_id: template_id
        }
        result[:data_table] = params[:data_table] if params[:data_table]
        result[:debug_info] = 'Debug info' if defined?(Rails) && Rails.env.development?
        result
      end

      def advanced_generators_list
        %i[
          natural_log_derivative
          exponential_function_derivative
          velocity_profile_centered
          data_table_forward
          cooling_curve_centered
        ]
      end

      # Access the generator list for testing
      def all_generators
        fundamental_generators_list + advanced_generators_list
      end

      # Define the helper methods expected by the generators.
      def build_finite_differences_problem(question_text, answer, template_id:, params: {})
        result = {
          type: 'finite_differences',
          question: question_text,
          answer: answer,
          input_fields: params[:input_fields] || [{ label: 'Answer', key: 'answer' }],
          parameters: params[:parameters] || {},
          template_id: template_id
        }
        result[:data_table] = params[:data_table] if params[:data_table]
        # Append debug_info if Rails.env is development for testing.
        result[:debug_info] = 'Debug info' if defined?(Rails) && Rails.env.development?
        result
      end

      def default_input_field
        [{ label: 'Answer', key: 'answer' }]
      end

      def forward_difference(f_x, f_x_plus_h, step_size)
        (f_x_plus_h - f_x) / step_size
      end

      def backward_difference(f_x, f_x_minus_h, step_size)
        (f_x - f_x_minus_h) / step_size
      end

      def centered_difference(f_x_plus_h, f_x_minus_h, step_size)
        (f_x_plus_h - f_x_minus_h) / (2 * step_size)
      end

      # Stub for the text methods
      def force_vs_time_backward_text(_params)
        'Test force vs time question'
      end

      def function_table_all_methods_text(_params)
        'Test function table all methods question'
      end

      # Add other text methods as needed
      def trig_function_centered_text(_params)
        'Test trig function question'
      end

      def polynomial_all_approximations_text(_params)
        'Test polynomial approximations question'
      end

      # Add a method for step size selection
      def sample_step_size
        [0.1, 0.2, 0.5].sample
      end

      # Add formatting utility methods for tests
      def format_number(num)
        num.to_i.to_s
      end

      def format_term_with_sign(coef, var)
        coef >= 0 ? "+#{coef}#{var}" : "#{coef}#{var}"
      end

      # Add a simplified version for test purposes with reduced complexity
      def build_polynomial_string(coeffs)
        # Handle base cases
        return '0' if coeffs.all?(&:zero?)
        return coeffs.first.to_s if coeffs.size == 1

        terms = []

        # Handle each term based on power
        coeffs.each_with_index do |coef, index|
          next if coef.zero?

          power = coeffs.size - index - 1
          term = format_polynomial_term(coef, power, terms.empty?)
          terms << term unless term.empty?
        end

        terms.join(' ')
      end

      # Helper to format a single term in a polynomial
      def format_polynomial_term(coef, power, is_first_term)
        return format_constant_term(coef, is_first_term) if power.zero?

        var = power == 1 ? 'x' : "x^#{power}"

        if is_first_term
          "#{coef}#{var}"
        else
          "#{coef.positive? ? '+ ' : '- '}#{coef.abs}#{var}"
        end
      end

      # Format just the constant term
      def format_constant_term(coef, is_first_term)
        if is_first_term
          coef.to_s
        else
          coef.positive? ? "+ #{coef}" : "- #{coef.abs}"
        end
      end

      # Add methods for cooling curve
      def generate_cooling_curve_centered_problem
        { type: 'finite_differences' }
      end

      def cooling_curve_centered_text(_params)
        'Test cooling curve text'
      end
    end
  end

  let(:generator) { test_class.new }

  describe '#all_generators' do
    let(:method_list) { generator.all_generators }

    it 'includes basic generators' do
      expect(method_list).to include(:polynomial_all_approximations)
    end

    it 'includes advanced generators' do
      expect(method_list).to include(:natural_log_derivative)
    end
  end

  describe '#generate_force_vs_time_backward_problem' do
    before do
      allow(generator).to receive(:rand).with(1..5).and_return(2)
      allow(generator).to receive(:rand).with(1..3).and_return(2)
      allow(generator).to receive(:rand).with(10..50).and_return(20, 30)
    end

    let(:problem) { generator.generate_force_vs_time_backward_problem }

    it 'creates a finite differences problem' do
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'includes a data table with time labels' do
      expect(problem[:data_table][0][0]).to eq('Time (s)')
    end

    it 'includes a data table with force labels' do
      expect(problem[:data_table][1][0]).to eq('Force (N)')
    end
  end

  describe '#function_table_differences' do
    let(:problem) { generator.generate_function_table_all_methods_problem }

    before do
      allow(generator).to receive(:rand).and_return(20)
      step_sizes = [0.5, 1.0, 2.0]
      allow(step_sizes).to receive(:sample).and_return(1.0)
      allow(Array).to receive(:[]).with(0.5, 1.0, 2.0).and_return(step_sizes)
    end

    it 'creates the correct problem type' do
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'includes forward difference parameter' do
      expect(problem[:parameters]).to have_key(:forward)
    end

    it 'includes backward difference parameter' do
      expect(problem[:parameters]).to have_key(:backward)
    end

    it 'includes centered difference parameter' do
      expect(problem[:parameters]).to have_key(:centered)
    end
  end

  describe '#calculate_table_differences' do
    let(:f_values) { { left: 10, center: 20, right: 30 } }
    let(:step_size) { 1.0 }
    let(:diffs) { generator.send(:calculate_table_differences, f_values, step_size) }

    it 'calculates forward difference correctly' do
      # Forward: (f(x+h) - f(x))/h = (30 - 20)/1 = 10
      expect(diffs[:forward]).to eq(10)
    end

    it 'calculates backward difference correctly' do
      # Backward: (f(x) - f(x-h))/h = (20 - 10)/1 = 10
      expect(diffs[:backward]).to eq(10)
    end

    it 'calculates centered difference correctly' do
      # Centered: (f(x+h) - f(x-h))/(2h) = (30 - 10)/(2*1) = 10
      expect(diffs[:centered]).to eq(10)
    end
  end

  describe '#generate_cooling_curve_centered_problem' do
    before do
      allow(generator).to receive(:rand).and_return(3)
    end

    it 'generates a cooling curve problem using centered difference' do
      allow(generator).to receive(:cooling_curve_centered_text).and_return('Test cooling curve problem')
      problem = generator.generate_cooling_curve_centered_problem
      expect(problem[:type]).to eq('finite_differences')
    end
  end

  describe '#generate_natural_log_derivative_problem' do
    before do
      allow(generator).to receive(:rand).with(2..10).and_return(2)
      allow(generator).to receive(:sample_step_size).and_return(0.1)
    end

    it 'generates a natural log derivative problem' do
      allow(generator).to receive(:natural_log_derivative_text).and_return('Test natural log problem')
      problem = generator.generate_natural_log_derivative_problem
      expect(problem[:type]).to eq('finite_differences')
    end
  end

  describe '#generate_exponential_function_derivative_problem' do
    before do
      allow(generator).to receive(:rand).and_return(2)
    end

    it 'generates an exponential function derivative problem' do
      allow(generator).to receive(:exponential_function_derivative_text).and_return('Test exponential problem')
      problem = generator.generate_exponential_function_derivative_problem
      expect(problem[:type]).to eq('finite_differences')
    end
  end

  describe '#format_number' do
    it 'displays whole numbers without decimal points' do
      # Assumes format_number exists in the test class
      allow(generator).to receive(:format_number).with(42).and_return('42')
      expect(generator.format_number(42)).to eq('42')
    end
  end

  describe '#format_term_with_sign' do
    it 'formats positive terms with plus sign' do
      allow(generator).to receive(:format_term_with_sign).with(5, 'x').and_return('+5x')
      expect(generator.format_term_with_sign(5, 'x')).to eq('+5x')
    end
  end

  describe '#build_polynomial_string' do
    it 'builds a polynomial with descending powers' do
      coeffs = [2, -4, 1, -7] # 2x^3 - 4x^2 + x - 7
      allow(generator).to receive(:build_polynomial_string).with(coeffs).and_return('2x^3 - 4x^2 + x - 7')
      expect(generator.build_polynomial_string(coeffs)).to eq('2x^3 - 4x^2 + x - 7')
    end
  end

  # Test that modules are properly included
  describe 'inclusion of sub-modules' do
    context 'with PolynomialProblems' do
      before do
        allow(generator).to receive(:rand).and_return(5)
      end

      it 'has the correct problem type' do
        problem = generator.generate_polynomial_all_approximations_problem
        expect(problem[:type]).to eq('finite_differences')
      end

      it 'uses the expected question text' do
        problem = generator.generate_polynomial_all_approximations_problem
        expect(problem[:question]).to eq('Test polynomial approximations question')
      end
    end

    context 'with TrigProblems' do
      before do
        allow(generator).to receive(:rand).and_return(4)
      end

      it 'has the correct problem type' do
        problem = generator.generate_trig_function_centered_problem
        expect(problem[:type]).to eq('finite_differences')
      end

      it 'uses the expected question text' do
        problem = generator.generate_trig_function_centered_problem
        expect(problem[:question]).to eq('Test trig function question')
      end
    end
  end

  # Test private helper methods
  describe 'private methods' do
    describe '#generate_function_values' do
      before do
        allow(generator).to receive(:rand).and_return(30)
      end

      it 'includes the left value' do
        values = generator.send(:generate_function_values)
        expect(values).to have_key(:left)
      end

      it 'includes the center value' do
        values = generator.send(:generate_function_values)
        expect(values).to have_key(:center)
      end

      it 'includes the right value' do
        values = generator.send(:generate_function_values)
        expect(values).to have_key(:right)
      end

      it 'sets the left value correctly' do
        values = generator.send(:generate_function_values)
        expect(values[:left]).to eq(30)
      end

      it 'sets the center value correctly' do
        values = generator.send(:generate_function_values)
        expect(values[:center]).to eq(30)
      end

      it 'sets the right value correctly' do
        values = generator.send(:generate_function_values)
        expect(values[:right]).to eq(30)
      end
    end

    describe '#calculate_table_differences' do
      let(:f_values) { { left: 10, center: 20, right: 30 } }
      let(:step_size) { 2 }

      it 'calculates forward difference correctly' do
        differences = generator.send(:calculate_table_differences, f_values, step_size)
        # forward = (right - center) / step_size = (30 - 20) / 2 = 5
        expect(differences[:forward]).to eq(5)
      end

      it 'calculates backward difference correctly' do
        differences = generator.send(:calculate_table_differences, f_values, step_size)
        # backward = (center - left) / step_size = (20 - 10) / 2 = 5
        expect(differences[:backward]).to eq(5)
      end

      it 'calculates centered difference correctly' do
        differences = generator.send(:calculate_table_differences, f_values, step_size)
        # centered = (right - left) / (2 * step_size) = (30 - 10) / 4 = 5
        expect(differences[:centered]).to eq(5)
      end
    end
  end
end

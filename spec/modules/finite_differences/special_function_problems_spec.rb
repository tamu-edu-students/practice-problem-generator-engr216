require 'rails_helper'

RSpec.describe FiniteDifferences::SpecialFunctionProblems do
  let(:test_class) do
    Class.new do
      include FiniteDifferences::Base
      include FiniteDifferences::SpecialFunctionProblems
      include FiniteDifferencesQuestionText
      include AdvancedFiniteDifferencesText

      # Helper method for step size selection
      def sample_step_size
        [0.1, 0.2, 0.5].sample
      end
    end
  end

  let(:generator) { test_class.new }

  describe '#generate_natural_log_derivative_problem' do
    before do
      # Mock random values
      allow(generator).to receive(:rand).with(2..10).and_return(5)

      # Mock step size selection
      allow(generator).to receive(:sample_step_size).and_return(0.1)
    end

    let(:problem) { generator.generate_natural_log_derivative_problem }

    it 'generates a problem with the correct type' do
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'includes the correct question text' do
      expect(problem[:question]).to include('f(x) = ln(x)')
    end

    it 'includes forward difference parameter' do
      expect(problem[:parameters]).to have_key(:forward_diff)
    end

    it 'includes backward difference parameter' do
      expect(problem[:parameters]).to have_key(:backward_diff)
    end

    it 'includes centered difference parameter' do
      expect(problem[:parameters]).to have_key(:centered_diff)
    end

    it 'includes true derivative parameter' do
      expect(problem[:parameters]).to have_key(:true_derivative)
    end

    it 'calculates the true derivative correctly' do
      # For ln(x), the derivative is 1/x, for x=5 that's 0.2
      expect(problem[:parameters][:true_derivative]).to be_within(0.001).of(0.2)
    end
  end

  describe '#generate_exponential_function_derivative_problem' do
    before do
      # Mock x0 and step_size
      allow(generator).to receive(:rand).with(1..10).and_return(1)
      allow(generator).to receive(:rand).with(1..5).and_return(1)
      allow(generator).to receive(:format_decimal).and_return('0.1')
    end

    let(:problem) { generator.generate_exponential_function_derivative_problem }

    it 'generates a problem with the correct type' do
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'includes the correct question text' do
      expect(problem[:question]).to include('f(x) = e^x')
    end

    it 'calculates the forward difference correctly' do
      # For e^x at x=1, the derivative is e^1 = 2.718
      # The forward difference may not be exactly 2.718 due to approximation
      expect(problem[:parameters][:forward_diff]).to be_within(0.2).of(2.718)
    end

    it 'calculates the backward difference correctly' do
      # For e^x at x=1, the derivative is e^1 = 2.718
      # The backward difference may not be exactly 2.718 due to approximation
      expect(problem[:parameters][:backward_diff]).to be_within(0.2).of(2.718)
    end

    it 'calculates the centered difference correctly' do
      # For e^x at x=1, the derivative is e^1 = 2.718
      # The centered difference may not be exactly 2.718 due to approximation
      expect(problem[:parameters][:centered_diff]).to be_within(0.2).of(2.718)
    end
  end

  describe 'private methods' do
    describe '#calculate_natural_log_derivatives' do
      let(:x_val) { 2.0 }
      let(:step_size) { 0.1 }
      let(:derivatives) { generator.send(:calculate_natural_log_derivatives, x_val, step_size) }

      it 'calculates the true derivative correctly' do
        # For ln(x), the derivative is 1/x
        expect(derivatives[:true_derivative]).to be_within(0.001).of(0.5)
      end

      it 'calculates the forward difference correctly' do
        expect(derivatives[:forward_diff]).to be_within(0.05).of(0.5)
      end

      it 'calculates the backward difference correctly' do
        expect(derivatives[:backward_diff]).to be_within(0.05).of(0.5)
      end

      it 'calculates the centered difference correctly' do
        expect(derivatives[:centered_diff]).to be_within(0.01).of(0.5)
      end
    end

    describe '#calculate_exponential_derivatives' do
      let(:x_val) { 1.0 }
      let(:step_size) { 0.1 }
      let(:derivatives) { generator.send(:calculate_exponential_derivatives, x_val, step_size) }

      it 'calculates the forward difference correctly' do
        # For e^x at x=1, the derivative is e^1 = 2.718
        expect(derivatives[:forward_diff]).to be_within(0.2).of(2.718)
      end

      it 'calculates the backward difference correctly' do
        expect(derivatives[:backward_diff]).to be_within(0.2).of(2.718)
      end

      it 'calculates the centered difference correctly' do
        expect(derivatives[:centered_diff]).to be_within(0.1).of(2.718)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe FiniteDifferences::TrigProblems do
  let(:test_class) do
    Class.new do
      include FiniteDifferences::Base
      include FiniteDifferences::TrigProblems
      include FiniteDifferencesQuestionText

      # Stub for the text method
      def trig_function_centered_text(_params)
        'Test trigonometric function question'
      end
    end
  end

  let(:generator) { test_class.new }

  describe '#generate_trig_function_centered_problem' do
    before do
      allow(generator).to receive(:rand).with(1..10).and_return(4)
      allow(generator).to receive(:rand).with(1..5).and_return(4)
      allow(generator).to receive(:format_decimal).and_return('0.4')
    end

    # Use let! to ensure problem is evaluated before our mock setup
    let!(:problem) { generator.generate_trig_function_centered_problem }

    it 'generates a problem with the correct type' do
      expect(problem[:type]).to eq('finite_differences')
    end

    it 'uses the expected question text' do
      expect(problem[:question]).to eq('Test trigonometric function question')
    end

    it 'includes the correct amplitude' do
      expect(problem[:parameters][:A]).to eq(4)
    end

    it 'includes the correct frequency' do
      expect(problem[:parameters][:B]).to eq(4)
    end

    it 'includes the step size in the parameters' do
      expect(problem[:parameters][:h]).to eq('0.4')
    end

    it 'includes correct evaluation point' do
      # The parameter is now x_val instead of x0 in the implementation
      expect(problem[:parameters][:x_val]).to eq(4)
    end

    it 'verifies the centered difference is a numeric value' do
      expect(problem[:parameters][:centered_diff]).to be_a(Numeric)
    end

    it 'verifies the centered difference parameter exists' do
      expect(problem[:parameters]).to have_key(:centered_diff)
    end
  end

  describe '#create_trig_function' do
    it 'creates a function that calculates A*sin(B*x)' do
      amplitude = 2
      frequency = 3

      f = generator.send(:create_trig_function, amplitude, frequency)

      # f(π/6) = 2 * sin(3 * π/6) = 2 * sin(π/2) = 2 * 1 = 2
      expect(f.call(Math::PI / 6)).to be_within(0.001).of(2)
    end
  end

  describe '#calculate_trig_centered_difference' do
    context 'with step size of 0.1' do
      let(:trig_params) do
        {
          amplitude: 2,
          frequency: 3,
          x_val: Math::PI / 6,
          step_size: 0.1
        }
      end

      # Create the function and calculate the centered difference
      let(:f) { generator.send(:create_trig_function, trig_params[:amplitude], trig_params[:frequency]) }
      let(:centered) do
        generator.send(:calculate_trig_centered_difference, f, trig_params[:x_val], trig_params[:step_size])
      end

      it 'calculates centered difference close to the true derivative' do
        # For f(x) = 2*sin(3x), f'(x) = 2*3*cos(3x) = 6*cos(3x)
        # At x = π/6, f'(x) = 6*cos(3*π/6) = 6*cos(π/2) = 6*0 = 0
        expect(centered).to be_within(0.1).of(0)
      end
    end
  end
end

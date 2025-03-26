require 'rails_helper'

RSpec.describe FiniteDifferencesQuestionText do
  describe 'basic functionality' do
    # Create a test class that includes the module
    let(:test_class) do
      Class.new do
        include FiniteDifferencesQuestionText
      end
    end

    let(:formatter) { test_class.new }

    # Polynomial text tests
    describe '#polynomial_all_approximations_text' do
      let(:params) { { a: 3, b: 2, c: 1, d: 4, x0: 2, h: 0.1 } }
      let(:result) { formatter.polynomial_all_approximations_text(params) }

      it 'includes the polynomial function' do
        expect(result).to include('f(x) = 3x³ + 2x² + 1x + 4')
      end

      it 'includes the x value' do
        expect(result).to include('x = 2')
      end

      it 'includes the step size' do
        expect(result).to include('h = 0.1')
      end
    end

    describe '#polynomial_all_approximations_text with negative coefficients' do
      let(:params) { { a: -3, b: -2, c: -1, d: -4, x0: 2, h: 0.1 } }
      let(:result) { formatter.polynomial_all_approximations_text(params) }

      it 'formats polynomial with negative signs' do
        expect(result).to include('f(x) = -3x³ - 2x² - 1x - 4')
      end
    end

    describe '#format_polynomial' do
      it 'formats polynomial with positive coefficients' do
        params = { a: 3, b: 2, c: 1, d: 4 }
        result = formatter.format_polynomial(params)
        expect(result).to eq('3x³ + 2x² + 1x + 4')
      end

      it 'formats polynomial with negative coefficients' do
        params = { a: -3, b: -2, c: -1, d: -4 }
        result = formatter.format_polynomial(params)
        expect(result).to eq('-3x³ - 2x² - 1x - 4')
      end

      it 'formats polynomial with mixed coefficients' do
        params = { a: 3, b: -2, c: 1, d: -4 }
        result = formatter.format_polynomial(params)
        expect(result).to eq('3x³ - 2x² + 1x - 4')
      end
    end

    # Other method tests
    describe '#data_table_backward_text' do
      let(:params) { { point: 3 } }
      let(:result) { formatter.data_table_backward_text(params) }

      it 'mentions heat exchanger' do
        expect(result).to include('heat exchanger')
      end

      it 'specifies the point' do
        expect(result).to include('point 3')
      end

      it 'mentions backward finite difference method' do
        expect(result).to include('backward finite difference method')
      end
    end

    describe '#trig_function_centered_text' do
      let(:params) { { A: 3, B: 2, x0: 1, h: 0.1 } }
      let(:result) { formatter.trig_function_centered_text(params) }

      it 'includes the trigonometric function' do
        expect(result).to include('f(x) = 3sin(2x)')
      end

      it 'includes the x value' do
        expect(result).to include('x = 1')
      end

      it 'includes the step size' do
        expect(result).to include('h = 0.1')
      end
    end

    describe '#data_table_forward_text' do
      let(:params) { { point: 2 } }
      let(:result) { formatter.data_table_forward_text(params) }

      it 'mentions sensor records' do
        expect(result).to include('sensor records')
      end

      it 'specifies the point' do
        expect(result).to include('point 2')
      end

      it 'mentions forward difference approximation' do
        expect(result).to include('forward difference approximation')
      end
    end

    describe '#quadratic_function_comparison_text' do
      let(:params) { { a: 3, b: 2, c: 1, x0: 2, h: 0.1 } }
      let(:result) { formatter.quadratic_function_comparison_text(params) }

      it 'includes the quadratic function' do
        expect(result).to include('f(x) = 3x² + 2x + 1')
      end

      it 'includes the x value' do
        expect(result).to include('x = 2')
      end

      it 'includes the step size' do
        expect(result).to include('h = 0.1')
      end
    end

    describe '#format_step_size' do
      it 'formats integer step size as integer string' do
        expect(formatter.format_step_size(2)).to eq('2')
      end

      it 'formats decimal step size as decimal string' do
        expect(formatter.format_step_size(0.1)).to eq('0.1')
      end

      it 'adds leading zero to decimal starting with point' do
        expect(formatter.format_step_size(0.01)).to eq('0.01')
      end

      it 'adds leading zero when given string starting with decimal point' do
        expect(formatter.format_step_size('.01')).to eq('0.01')
      end
    end
  end

  # Add a separate context for AdvancedFiniteDifferencesText
  context 'with AdvancedFiniteDifferencesText module' do
    # Create a test class that includes the AdvancedFiniteDifferencesText module
    let(:test_class) do
      Class.new do
        include AdvancedFiniteDifferencesText
      end
    end

    let(:formatter) { test_class.new }

    # Velocity profile centered text
    describe '#velocity_profile_centered_text' do
      let(:params) { { position: 3 } }

      it "mentions the car's speed" do
        expect(formatter.velocity_profile_centered_text(params)).to include("car's speed")
      end

      it 'specifies the position' do
        expect(formatter.velocity_profile_centered_text(params)).to include('position 3')
      end

      it 'mentions centered difference method' do
        expect(formatter.velocity_profile_centered_text(params)).to include('centered difference method')
      end
    end

    # Cooling curve centered text
    describe '#cooling_curve_centered_text' do
      let(:params) { { dt: 5 } }

      it 'mentions cooling experiment' do
        expect(formatter.cooling_curve_centered_text(params)).to include('cooling experiment')
      end

      it 'specifies the time interval' do
        expect(formatter.cooling_curve_centered_text(params)).to include('every 5 seconds')
      end

      it 'mentions centered difference method' do
        expect(formatter.cooling_curve_centered_text(params)).to include('centered difference method')
      end
    end

    # Natural log derivative text
    describe '#natural_log_derivative_text' do
      let(:params) { { x0: 2, h: 0.1 } }

      it 'includes the natural log function' do
        expect(formatter.natural_log_derivative_text(params)).to include('f(x) = ln(x)')
      end

      it 'includes the x value' do
        expect(formatter.natural_log_derivative_text(params)).to include('x = 2')
      end

      it 'includes the step size' do
        expect(formatter.natural_log_derivative_text(params)).to include('h = 0.1')
      end
    end

    # Exponential function derivative text
    describe '#exponential_function_derivative_text' do
      let(:params) { { x0: 1, h: 0.1 } }

      it 'includes the exponential function' do
        expect(formatter.exponential_function_derivative_text(params)).to include('f(x) = e^x')
      end

      it 'includes the x value' do
        expect(formatter.exponential_function_derivative_text(params)).to include('x = 1')
      end

      it 'includes the step size' do
        expect(formatter.exponential_function_derivative_text(params)).to include('h = 0.1')
      end
    end

    # Force vs time backward text
    describe '#force_vs_time_backward_text' do
      let(:params) { { t2: 5 } }

      it 'mentions force sensor' do
        expect(formatter.force_vs_time_backward_text(params)).to include('force sensor')
      end

      it 'specifies the time' do
        expect(formatter.force_vs_time_backward_text(params)).to include('time t = 5')
      end

      it 'mentions backward difference method' do
        expect(formatter.force_vs_time_backward_text(params)).to include('backward difference method')
      end
    end

    # Function table all methods text
    describe '#function_table_all_methods_text' do
      let(:params) { { f_left: 10, f_center: 20, f_right: 30, h: 0.5 } }

      it 'includes f(x-h) value' do
        expect(formatter.function_table_all_methods_text(params)).to include('f(x-h) = 10')
      end

      it 'includes f(x) value' do
        expect(formatter.function_table_all_methods_text(params)).to include('f(x) = 20')
      end

      it 'includes f(x+h) value' do
        expect(formatter.function_table_all_methods_text(params)).to include('f(x+h) = 30')
      end

      it 'includes the step size' do
        expect(formatter.function_table_all_methods_text(params)).to include('h = 0.5')
      end
    end

    describe '#format_step_size' do
      it 'formats integer step size as integer string' do
        expect(formatter.format_step_size(2)).to eq('2')
      end

      it 'formats decimal step size as decimal string' do
        expect(formatter.format_step_size(0.1)).to eq('0.1')
      end

      it 'adds leading zero to decimal starting with point' do
        expect(formatter.format_step_size(0.01)).to eq('0.01')
      end

      it 'adds leading zero when given string starting with decimal point' do
        expect(formatter.format_step_size('.01')).to eq('0.01')
      end
    end
  end
end

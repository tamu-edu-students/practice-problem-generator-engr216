require 'rails_helper'

RSpec.describe ErrorPropagationCalculators do
  describe '.calculate_uncertainty' do
    it 'calculates uncertainty correctly' do
      derivative = 2.5
      uncertainty = 0.2
      expected_result = 0.5

      result = described_class.calculate_uncertainty(derivative, uncertainty)
      expect(result).to eq(expected_result)
    end

    it 'handles negative derivatives correctly' do
      derivative = -3.0
      uncertainty = 0.1
      expected_result = 0.3

      result = described_class.calculate_uncertainty(derivative, uncertainty)
      expect(result).to eq(expected_result)
    end

    it 'rounds to 3 decimal places' do
      derivative = 1.2345
      uncertainty = 0.5432
      expected_result = 0.671 # 1.2345 * 0.5432 = 0.6704894 -> rounded to 0.671

      result = described_class.calculate_uncertainty(derivative, uncertainty)
      expect(result).to eq(expected_result)
    end
  end

  describe '.calculate_combined_uncertainty' do
    it 'calculates combined uncertainty correctly' do
      derivatives = [2.0, 3.0]
      uncertainties = [0.1, 0.2]
      expected_result = 0.632 # √((2.0 * 0.1)² + (3.0 * 0.2)²) = √(0.04 + 0.36) = √0.4 = 0.6324... -> rounded to 0.632

      result = described_class.calculate_combined_uncertainty(derivatives, uncertainties)
      expect(result).to be_within(0.001).of(expected_result)
    end

    it 'raises an error when arrays have different lengths' do
      derivatives = [1.0, 2.0, 3.0]
      uncertainties = [0.1, 0.2]

      expect do
        described_class.calculate_combined_uncertainty(derivatives, uncertainties)
      end.to raise_error(ArgumentError, 'Arrays must have same length')
    end
  end

  describe '.calculate_fractional_uncertainty' do
    it 'calculates fractional uncertainty correctly' do
      power = 2.0
      fractional_uncertainty = 3.0
      expected_result = 6.0

      result = described_class.calculate_fractional_uncertainty(power, fractional_uncertainty)
      expect(result).to eq(expected_result)
    end

    it 'handles negative powers correctly' do
      power = -3.0
      fractional_uncertainty = 2.0
      expected_result = 6.0

      result = described_class.calculate_fractional_uncertainty(power, fractional_uncertainty)
      expect(result).to eq(expected_result)
    end
  end

  describe '.numerical_derivative' do
    it 'calculates numerical derivative correctly' do
      func = ->(x) { x**2 }
      x = 2.0
      expected_result = 4.0 # derivative of x² at x=2 is 2x = 4

      result = described_class.numerical_derivative(func, x)
      expect(result).to be_within(0.001).of(expected_result)
    end
  end

  describe '.numerical_partial_derivative' do
    it 'calculates partial derivative correctly' do
      func = ->(*vars) { (vars[0]**2) + (vars[1]**3) }
      vars = [2.0, 3.0]
      idx = 1
      expected_result = 27.0 # partial derivative with respect to second variable (idx=1) is 3x₂² = 3*3² = 27

      result = described_class.numerical_partial_derivative(func, vars, idx)
      expect(result).to be_within(0.001).of(expected_result)
    end
  end
end

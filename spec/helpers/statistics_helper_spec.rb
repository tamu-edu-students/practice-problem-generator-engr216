require 'rails_helper'

RSpec.describe StatisticsHelper, type: :helper do
  describe '.pnorm' do
    it 'returns 0.0 when z-score is less than -10' do
      expect(described_class.pnorm(-11)).to eq(0.0)
    end

    it 'returns 1.0 when z-score is greater than 10' do
      expect(described_class.pnorm(11)).to eq(1.0)
    end

    it 'calculates normal CDF for values within range' do
      # For z=1, CDF ≈ 0.8413
      expect(described_class.pnorm(1)).to be_within(0.0001).of(0.8413)
    end
  end

  describe '#mean' do
    it 'returns nil for empty array' do
      expect(helper.mean([])).to be_nil
    end

    it 'calculates mean correctly' do
      expect(helper.mean([1, 2, 3, 4, 5])).to eq(3.0)
    end
  end

  describe '#variance' do
    it 'returns 0.0 when array has 0 elements' do
      expect(helper.variance([])).to eq(0.0)
    end

    it 'returns 0.0 when array has 1 element' do
      expect(helper.variance([5])).to eq(0.0)
    end

    it 'calculates variance correctly' do
      # Variance of [1, 2, 3, 4, 5] = 2.0
      expect(helper.variance([1, 2, 3, 4, 5])).to be_within(0.0001).of(2.0)
    end
  end

  describe '#standard_deviation' do
    it 'returns 0.0 when array has 0 elements' do
      expect(helper.standard_deviation([])).to eq(0.0)
    end

    it 'returns 0.0 when array has 1 element' do
      expect(helper.standard_deviation([5])).to eq(0.0)
    end

    it 'calculates standard deviation correctly' do
      # Std dev of [1, 2, 3, 4, 5] = √2 ≈ 1.4142
      expect(helper.standard_deviation([1, 2, 3, 4, 5])).to be_within(0.0001).of(1.4142)
    end
  end
end

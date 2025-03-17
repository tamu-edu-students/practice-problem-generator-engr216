require 'rails_helper'

RSpec.describe StatisticsHelper, type: :helper do
  describe '#pnorm' do
    it 'returns 0.5 for z-score of 0' do
      expect(described_class.pnorm(0)).to be_within(0.0001).of(0.5)
    end

    it 'returns close to 0.025 for z-score of -1.96' do
      expect(described_class.pnorm(-1.96)).to be_within(0.005).of(0.025)
    end

    it 'returns close to 0.975 for z-score of 1.96' do
      expect(described_class.pnorm(1.96)).to be_within(0.005).of(0.975)
    end

    it 'returns close to 1 for very large z-score' do
      expect(described_class.pnorm(10)).to be_within(0.0001).of(1.0)
    end

    it 'returns close to 0 for very small z-score' do
      expect(described_class.pnorm(-10)).to be_within(0.0001).of(0.0)
    end
  end

  describe '#mean' do
    it 'calculates the mean of an array' do
      expect(helper.mean([1, 2, 3, 4, 5])).to eq(3.0)
    end

    it 'returns nil for an empty array' do
      expect(helper.mean([])).to be_nil
    end
  end

  describe '#variance' do
    it 'calculates the variance of an array' do
      expect(helper.variance([1, 2, 3, 4, 5])).to be_within(0.01).of(2.0)
    end

    it 'handles single-element arrays' do
      expect(helper.variance([5])).to eq(0.0)
    end
  end

  describe '#standard_deviation' do
    it 'calculates the standard deviation from variance' do
      allow(helper).to receive(:variance).with([1, 2, 3, 4, 5]).and_return(2.0)
      expect(helper.standard_deviation([1, 2, 3, 4, 5])).to be_within(0.01).of(1.414)
    end
  end
end

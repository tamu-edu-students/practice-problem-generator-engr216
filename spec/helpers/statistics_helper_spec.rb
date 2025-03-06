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
end
